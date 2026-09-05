# cingere

Latin: to gird. Tmux bar on top, Claude statusline below. One belt, two edges.

Catppuccin mocha, pipes `┃`, nerd glyphs, holon red, GrokNight paper `#141414`.
The tmux row is host · session · windows · cpu/mem sparks · load · procs · uptime · clock.
The Claude row is folder · model · git · context spark · cache · output · diff · cost · effort · 5h/7d caps.

## Layout

```
tmux.conf              → ~/.tmux.conf
tmux/                  → ~/.config/tmux/
  spark.sh             fat braille cpu/mem (⣀ ⣤ ⣶ ⣿)
  procs.sh when.sh uptime.sh temp.sh marquee.sh
  holon                attach-or-create session `holon`
claude/statusline      → ~/.claude/statusline
gallery/               icon menus (Ghostty + Hack + Symbols Nerd Font Mono)
```

`tmux.conf` still calls `$HOME/.config/tmux/…`. Install makes that the repo's `tmux/` directory.

## Install

```bash
git clone https://github.com/watmin/cingere.git ~/work/cingere
~/work/cingere/install
tmux source-file ~/.tmux.conf
```

That symlinks the three paths above and writes Claude's `statusLine` into
`~/.claude/settings.json` (backup `settings.json.bak.cingere` if it had to
change). Existing real files are moved aside once as `*.bak.cingere`.

Bar style is `@bar_style` in `tmux.conf`: `ghost` | `pipes` | `chips` | `pills` | `slant`. Live is `pipes`.

Claude reloads the statusline script on the next refresh. A change to
`statusLine` in settings.json is picked up without a restart.

## Gallery

Open `gallery/index.html` in Ghostty. `gallery/claude-status.html` is the
Claude icon menu. Fonts are `local("Hack")` / `local("Symbols Nerd Font Mono")`
— Ghostty already has them. Drop the `.ttf` files next to the HTML only if
you are previewing somewhere that does not.

## Claude snippet

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline",
    "padding": 0,
    "refreshInterval": 15
  }
}
```
