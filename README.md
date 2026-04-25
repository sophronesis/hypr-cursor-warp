# hypr-cursor-warp

proportional cursor crossing between hyprland monitors. fixes two annoyances when you have monitors of different sizes (or rotated ones):

1. **live cross**: when the cursor naturally crosses to a neighbor monitor, snap its y-position proportionally. cursor at 40% down on the source monitor lands at 40% down on the target, instead of jumping to whatever absolute pixel happens to line up.
2. **dead-zone warp**: if you push the cursor against an edge where there's no neighbor at that y, but there *is* a neighbor at a different y, warp to that neighbor at the proportional position. no more "cursor stuck in a corner" with mismatched monitor heights.

handles rotated monitors correctly (transforms 1/3/5/7 swap effective width/height).

## install

requires python 3 and a running hyprland session. no other deps.

```bash
curl -L https://raw.githubusercontent.com/sophronesis/hypr-cursor-warp/main/hypr-cursor-warp -o ~/.local/bin/hypr-cursor-warp
chmod +x ~/.local/bin/hypr-cursor-warp
```

then in `~/.config/hypr/hyprland.conf`:

```
exec-once = hypr-cursor-warp
```

## env vars

| var | default | meaning |
| --- | --- | --- |
| `HYPR_WARP_LIVE` | `1` | enable live edge-crossing snap |
| `HYPR_WARP_DEAD` | `1` | enable dead-zone warp |
| `HYPR_WARP_HZ`   | `120` | poll rate (cursor position) |
| `HYPR_WARP_DEBUG`| `0` | verbose logs |

## how it works

polls `cursorpos` at `HYPR_WARP_HZ` and listens to hyprland's event socket for monitor add/remove/configreload to refresh the layout cache. all geometry comes from `hyprctl monitors -j` with transform-aware width/height.

## license

MIT
