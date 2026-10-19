# FARHOLLOW

A cozy 2D open-world RPG. Build your life, explore, adventure.

## Foundation (built)

- **Town**: 40x30 tile village with 4 houses, central stone plaza with well,
  dirt paths, fenced garden, trees, and decorative details
- **Player**: 8-direction smooth movement (WASD + arrows), collision
- **NPCs**: 3 villagers placed around town (elder, smith, girl)
- **Camera**: Smooth-follow Camera2D at 3x zoom
- **Rendering**: Pixel-perfect (Nearest filter, canvas_items stretch, 480x270 viewport)

## Project Structure

```
new-rpg/
├── project.godot          # Godot 4.3 project, named FARHOLLOW
├── icon.svg               # Project icon
├── scenes/
│   └── main.tscn          # Main scene
├── scripts/
│   ├── main.gd            # Scene setup, input, NPC spawning
│   ├── player.gd          # 8-direction movement controller
│   ├── npc.gd             # Static NPC with collision
│   └── town_builder.gd    # Builds TileSet + paints town from JSON
├── assets/
│   ├── tilesets/
│   │   └── town_tiles.png # Kenney Tiny Town (CC0)
│   └── characters/
│       ├── player.png     # Player sprite (Kenney, CC0)
│       ├── npc_elder.png  # Elder NPC (Kenney, CC0)
│       ├── npc_smith.png  # Smith NPC (Kenney, CC0)
│       └── npc_girl.png   # Girl NPC (Kenney, CC0)
└── tools/
    ├── town_layout.json   # Town tile data (ground + objects layers)
    ├── town_preview.py    # Python preview renderer
    └── screenshot.gd      # Godot screenshot tool (needs GPU)
```

## Assets

All art is Kenney (CC0, public domain):
- Tiles: Tiny Town pack (16x16 top-down)
- Characters: Roguelike Characters pack (16x16 paper-doll)

## Running

Open in Godot 4.3+ and press Play. Or:
```
godot --path ~/workspace/new-rpg
```

## Not Yet Built

Dialogue, inventory, day/night, farming, fishing, combat, housing, menus.
