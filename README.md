# cingere

Latin: to gird. Tmux bar on top, Claude statusline below. One belt, two edges.

Catppuccin mocha, pipes `┃`, nerd glyphs, holon red, GrokNight paper `#141414`.
The tmux row is host · session · windows · cpu/mem sparks · load · procs · uptime · clock.
The Claude row is folder · model · git · context spark · cache · output · diff · cost · effort · 5h/7d caps.

## Layout

```
holon                  → ~/.local/bin/holon   (the command you type)
tmux.conf              → ~/.tmux.conf
tmux/                  → ~/.config/tmux/      (bar helpers only)
  spark.sh procs.sh when.sh uptime.sh temp.sh marquee.sh
claude/statusline      → ~/.claude/statusline
gallery/               icon menus
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

Rendered: [watmin.github.io/cingere](https://watmin.github.io/cingere/)

GitHub's file view will not paint HTML — that is Pages. The site is the
`gallery/` folder. Fonts load from jsDelivr (Hack + Symbols Nerd Font Mono)
so the glyphs show in a browser, not only in Ghostty.

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
