"""Renders FARHOLLOW with proper layers: ground + objects."""
from PIL import Image
import random, json

TILEMAP = Image.open('/home/hatch/workspace/new-rpg/assets/tilesets/town_tiles.png').convert('RGBA')
T = 16

def tile(c, r):
    return TILEMAP.crop((c*T, r*T, c*T+T, r*T+T))

# Tiles
GRASS, GRASS_F1, GRASS_F2 = (1,0), (0,0), (2,0)
DIRT_TL, DIRT_T, DIRT_TR = (0,1), (1,1), (2,1)
DIRT_L,  DIRT_C, DIRT_R  = (0,2), (1,2), (2,2)
DIRT_BL, DIRT_B, DIRT_BR = (0,3), (1,3), (2,3)
PINE_T, PINE_B = (4,0), (4,1)
AUTUMN_T, AUTUMN_B = (3,0), (3,1)
RB_TL, RB_TR = (0,4), (1,4)
RB_BL, RB_BR = (0,5), (1,5)
WALL_L, WALL_M, WALL_R = (0,6), (1,6), (2,6)
WIN, DOOR, DOOR2, WIN2 = (0,7), (1,7), (2,7), (3,7)
FENCE_TL, FENCE_T, FENCE_TR = (8,2), (9,2), (10,2)
FENCE_L, FENCE_R = (8,3), (10,3)
FENCE_BL, FENCE_B, FENCE_BR = (8,4), (9,4), (10,4)
WELL_TOP, WELL_BOT = (8,7), (7,8)
SIGN, BARREL, CRATE, MUSHROOM = (9,6), (10,8), (9,10), (6,1)
STONE_TL, STONE_T, STONE_TR = (0,8), (1,8), (2,8)
STONE_L, STONE_C, STONE_R = (0,9), (1,9), (2,9)
STONE_BL, STONE_B, STONE_BR = (0,10), (1,10), (2,10)

W, H = 40, 30
# Two layers: ground (opaque tiles) and objects (transparent overlays)
ground = [[None]*W for _ in range(H)]
objects = [[None]*W for _ in range(H)]

def g(x, y, t):
    if 0 <= x < W and 0 <= y < H: ground[y][x] = t
def o(x, y, t):
    if 0 <= x < W and 0 <= y < H: objects[y][x] = t

def house(x, y, door_pos=1):
    # Roof (objects layer - has transparency)
    o(x, y, RB_TL); o(x+1, y, RB_TR); o(x+2, y, RB_TR)
    o(x, y+1, RB_BL); o(x+1, y+1, RB_BR); o(x+2, y+1, RB_BR)
    # Walls
    o(x, y+2, WALL_L); o(x+1, y+2, WALL_M); o(x+2, y+2, WALL_R)
    for i in range(3):
        o(x+i, y+3, DOOR if i == door_pos else (WIN if i == 0 else WIN2))

def tree_pine(x, y):
    o(x, y, PINE_T); o(x, y+1, PINE_B)
def tree_autumn(x, y):
    o(x, y, AUTUMN_T); o(x, y+1, AUTUMN_B)

# === GROUND LAYER ===
# Plaza
for dy in range(4):
    for dx in range(6):
        if dy == 0: t = [STONE_TL, STONE_T, STONE_T, STONE_T, STONE_T, STONE_TR][dx]
        elif dy == 3: t = [STONE_BL, STONE_B, STONE_B, STONE_B, STONE_B, STONE_BR][dx]
        else: t = [STONE_L, STONE_C, STONE_C, STONE_C, STONE_C, STONE_R][dx]
        g(17+dx, 13+dy, t)
# Dirt paths
for x in range(8, 17): g(x, 14, DIRT_C); g(x, 15, DIRT_C)
for x in range(23, 29): g(x, 14, DIRT_C); g(x, 15, DIRT_C)
for y in range(9, 13): g(19, y, DIRT_C); g(20, y, DIRT_C)
for y in range(17, 20): g(19, y, DIRT_C); g(20, y, DIRT_C)
# Garden dirt
for y in range(19, 21):
    for x in range(10, 14): g(x, y, DIRT_C)

# === OBJECTS LAYER ===
# Well
o(19, 14, WELL_TOP); o(19, 15, WELL_BOT)
# Houses
house(5, 5, 1); house(29, 5, 1); house(5, 20, 2); house(29, 20, 0)
# Trees
tree_pine(1,1); tree_autumn(3,1); tree_pine(36,1); tree_autumn(38,1)
tree_pine(1,26); tree_autumn(3,26); tree_pine(36,26); tree_autumn(38,26)
tree_pine(0,13); tree_pine(0,15); tree_autumn(39,13); tree_autumn(39,15)
tree_pine(13,2); tree_autumn(25,2); tree_pine(13,26); tree_autumn(26,26)
# Fences
for x in range(10,14): o(x, 18, FENCE_T)
o(9,18,FENCE_TL); o(14,18,FENCE_TR)
for x in range(10,14): o(x, 21, FENCE_B)
o(9,21,FENCE_BL); o(14,21,FENCE_BR)
o(9,19,FENCE_L); o(9,20,FENCE_L); o(14,19,FENCE_R); o(14,20,FENCE_R)
# Details
o(16,11,MUSHROOM); o(24,17,BARREL); o(15,17,CRATE); o(23,11,SIGN)

# Render: ground first, then objects
out = Image.new('RGBA', (W*T, H*T), (0,0,0,255))
for y in range(H):
    for x in range(W):
        t = ground[y][x]
        if t is None:
            random.seed(x*7919 + y*104729)
            r = random.random()
            t = GRASS_F1 if r < 0.04 else (GRASS_F2 if r < 0.08 else GRASS)
        tl = tile(t[0], t[1])
        out.paste(tl, (x*T, y*T))
# Objects layer
for y in range(H):
    for x in range(W):
        t = objects[y][x]
        if t is not None:
            tl = tile(t[0], t[1])
            out.paste(tl, (x*T, y*T), tl)

out = out.resize((out.size[0]*2, out.size[1]*2), Image.NEAREST)
out.save('/tmp/farhollow-preview.png')
print("Preview saved")

# Export both layers for Godot
def export_layer(layer):
    return [[x, y, t[0], t[1]] for y in range(H) for x in range(W) if (t := layer[y][x])]
with open('/home/hatch/workspace/new-rpg/tools/town_layout.json', 'w') as f:
    json.dump({"width": W, "height": H,
               "ground": export_layer(ground),
               "objects": export_layer(objects)}, f)
print("Layout exported with layers")
