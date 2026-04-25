# hypr-cursor-warp

Proportional cursor crossing between Hyprland monitors. Solves two common annoyances on multi-monitor setups with mismatched sizes or rotated displays:

1. **Live cross**: When the cursor naturally crosses to a neighboring monitor, its y-position is snapped proportionally. A cursor at 40% down on the source monitor lands at 40% down on the target, instead of jumping to whatever absolute pixel happens to line up.
2. **Dead-zone warp**: If the cursor is pushed against an edge where no neighbor exists at that y, but a neighbor exists at a different y, the cursor warps to that neighbor at the proportional position. This eliminates the "stuck in a corner" problem on layouts with mismatched monitor heights.

Rotated monitors are handled correctly: transforms 1, 3, 5, and 7 swap effective width and height.

## Installation

Requires Python 3 and a running Hyprland session. No other dependencies.

```bash
curl -L https://raw.githubusercontent.com/sophronesis/hypr-cursor-warp/main/hypr-cursor-warp \
  -o ~/.local/bin/hypr-cursor-warp
chmod +x ~/.local/bin/hypr-cursor-warp
```

Then add the following to `~/.config/hypr/hyprland.conf`:

```
exec-once = hypr-cursor-warp
```

## Configuration

Behavior is controlled via environment variables:

| Variable           | Default | Description                            |
| ------------------ | ------- | -------------------------------------- |
| `HYPR_WARP_LIVE`   | `1`     | Enable live edge-crossing snap         |
| `HYPR_WARP_DEAD`   | `1`     | Enable dead-zone warp                  |
| `HYPR_WARP_HZ`     | `120`   | Cursor poll rate in Hz                 |
| `HYPR_WARP_DEBUG`  | `0`     | Verbose logging                        |

## How it works

The daemon polls `cursorpos` at `HYPR_WARP_HZ` and listens on Hyprland's event socket for `monitoradded`, `monitorremoved`, and `configreloaded` events to keep its layout cache in sync. All geometry is derived from `hyprctl monitors -j`, with width and height swapped for any 90-degree transform.

## License

MIT
