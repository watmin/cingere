#!/usr/bin/env python3
"""Braille sparkline: 8 cells, two samples each (left = prior, right = now).

Usage: spark.sh cpu | mem

Each column is 4 buckets: 0-24 25-49 50-74 75-100. Floor is the bottom
dot, never blank. 16 samples in 8 glyphs; INTERVAL 10s → ~160s of history.
"""
import os
import sys
import time
from pathlib import Path

KIND = sys.argv[1] if len(sys.argv) > 1 else "cpu"
SAMPLES = 16
INTERVAL = 10.0

runtime = Path(os.environ.get("XDG_RUNTIME_DIR") or f"/tmp/tmux-{os.getuid()}")
try:
    runtime.mkdir(parents=True, exist_ok=True)
except OSError:
    runtime = Path("/tmp")
state = runtime / f"tmux-spark-{KIND}"

# left column dots 7,3,2,1 (bottom → top); right 8,6,5,4
LEFT = (0x40, 0x44, 0x46, 0x47)
RIGHT = (0x80, 0xA0, 0xB0, 0xB8)


def cpu_pct(prev_t, prev_i, total, idle):
    dt, di = total - prev_t, idle - prev_i
    if dt <= 0:
        return 0.0
    return max(0.0, min(100.0, 100.0 * (1.0 - di / dt)))


def read_cpu():
    with open("/proc/stat", encoding="ascii") as fh:
        nums = [int(x) for x in fh.readline().split()[1:]]
    idle = nums[3] + (nums[4] if len(nums) > 4 else 0)
    return float(sum(nums)), float(idle)


def read_mem():
    info = {}
    with open("/proc/meminfo", encoding="ascii") as fh:
        for line in fh:
            key, raw, *_ = line.replace(":", " ").split()
            info[key] = float(raw)
    total = info.get("MemTotal") or 1.0
    avail = info.get("MemAvailable")
    if avail is None:
        avail = info.get("MemFree", 0.0) + info.get("Buffers", 0.0) + info.get("Cached", 0.0)
    return max(0.0, min(100.0, 100.0 * (1.0 - avail / total)))


def height(pct: float) -> int:
    """1..4 for 0-24, 25-49, 50-74, 75-100."""
    if pct >= 75:
        return 4
    if pct >= 50:
        return 3
    if pct >= 25:
        return 2
    return 1


def pad(hist: list[float]) -> list[float]:
    hist = hist[-SAMPLES:]
    while len(hist) < SAMPLES:
        hist.insert(0, hist[0] if hist else 0.0)
    return hist


def cell(prior: float, now: float) -> str:
    bits = LEFT[height(prior) - 1] | RIGHT[height(now) - 1]
    return chr(0x2800 + bits)


def render(hist: list[float]) -> None:
    hist = pad(hist)
    print("".join(cell(hist[i], hist[i + 1]) for i in range(0, SAMPLES, 2)), end="")


def load():
    """Return (ts, meta_total, meta_idle, hist) or None if missing/stale format."""
    if not state.exists():
        return None
    parts = state.read_text().split()
    # v2: "10s" <epoch> [<total> <idle>] <hist...>
    if len(parts) < 2 or parts[0] != "10s":
        return None
    try:
        ts = float(parts[1])
        rest = [float(x) for x in parts[2:]]
    except ValueError:
        return None
    if KIND == "cpu":
        if len(rest) < 2:
            return None
        return ts, rest[0], rest[1], rest[2:]
    return ts, 0.0, 0.0, rest


def save(ts: float, total: float, idle: float, hist: list[float]) -> None:
    hist = pad(hist)
    if KIND == "cpu":
        payload = ["10s", f"{ts:.0f}", f"{total:.0f}", f"{idle:.0f}", *(f"{x:.1f}" for x in hist)]
    else:
        payload = ["10s", f"{ts:.0f}", *(f"{x:.1f}" for x in hist)]
    state.write_text(" ".join(payload))


now = time.time()
loaded = load()

if KIND == "cpu":
    total, idle = read_cpu()
    if loaded is None:
        save(now, total, idle, [])
        render([])
        raise SystemExit(0)
    ts, prev_t, prev_i, hist = loaded
    if now - ts >= INTERVAL:
        hist.append(cpu_pct(prev_t, prev_i, total, idle))
        save(now, total, idle, hist)
    else:
        total, idle, hist = prev_t, prev_i, hist
    render(hist)
else:
    pct = read_mem()
    if loaded is None:
        save(now, 0.0, 0.0, [pct])
        render([pct])
        raise SystemExit(0)
    ts, _, _, hist = loaded
    if now - ts >= INTERVAL:
        hist.append(pct)
        save(now, 0.0, 0.0, hist)
    render(hist)
