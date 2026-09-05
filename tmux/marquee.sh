#!/usr/bin/env python3
"""Fixed-width scrolling ticker. Width 8. One codepoint per second."""
import os
import time

WIDTH = 8
msg = os.environ.get("HOLON_MARQUEE", "  holon  ·  algebraic intelligence  ·  ")
if len(msg) < WIDTH:
    msg = msg + " " * (WIDTH - len(msg))
loop = msg + msg
i = int(time.time()) % len(msg)
print(loop[i : i + WIDTH], end="")
