extends Node2D
## FARHOLLOW - Town Builder
## Creates the TileSet from Kenney tiles and paints the town map.

const TILE_SIZE := 16
const ATLAS_COLS := 12
const ATLAS_ROWS := 11

# Tiles that block movement (house parts, trees, fences, well, etc.)
const SOLID_TILES := [
	# House roofs
	Vector2i(0, 4), Vector2i(1, 4),
	Vector2i(0, 5), Vector2i(1, 5),
	# House walls
	Vector2i(0, 6), Vector2i(1, 6), Vector2i(2, 6),
	# House doors/windows (solid for now - no interiors yet)
	Vector2i(0, 7), Vector2i(1, 7), Vector2i(2, 7), Vector2i(3, 7),
	# Trees
	Vector2i(4, 0), Vector2i(4, 1),
	Vector2i(3, 0), Vector2i(3, 1),
	# Fences
	Vector2i(8, 2), Vector2i(9, 2), Vector2i(10, 2),
	Vector2i(8, 3), Vector2i(10, 3),
	Vector2i(8, 4), Vector2i(9, 4), Vector2i(10, 4),
	Vector2i(8, 5), Vector2i(11, 2),
	# Well
	Vector2i(8, 7), Vector2i(7, 8),
	# Sign, barrel, crate
	Vector2i(9, 6), Vector2i(10, 8), Vector2i(9, 10),
]

var ground_layer: TileMapLayer
var objects_layer: TileMapLayer

func _ready() -> void:
	var tileset := _build_tileset()
	
	ground_layer = TileMapLayer.new()
	ground_layer.name = "Ground"
	ground_layer.tile_set = tileset
	add_child(ground_layer)
	
	objects_layer = TileMapLayer.new()
	objects_layer.name = "Objects"
	objects_layer.tile_set = tileset
	# Objects render above ground; y-sort for depth
	objects_layer.y_sort_enabled = true
	add_child(objects_layer)
	
	_paint_town()

func _build_tileset() -> TileSet:
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	
	# Physics layer for collision (must be added before tiles use it)
	tileset.add_physics_layer(0)
	
	# Atlas source from Kenney tilemap
	var atlas := TileSetAtlasSource.new()
	var texture: Texture2D = load("res://assets/tilesets/town_tiles.png")
	atlas.texture = texture
	atlas.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	atlas.separation = Vector2i(0, 0)
	atlas.margins = Vector2i(0, 0)
	
	# Add source to tileset FIRST so tile_data can access physics layers
	tileset.add_source(atlas, 0)
	
	# Create all tiles in the 12x11 atlas
	for y in range(ATLAS_ROWS):
		for x in range(ATLAS_COLS):
			var coords := Vector2i(x, y)
			atlas.create_tile(coords)
			
			# Add full-tile collision for solid tiles
			if coords in SOLID_TILES:
				var tile_data := atlas.get_tile_data(coords, 0)
				var half := TILE_SIZE / 2.0
				tile_data.add_collision_polygon(0)
				tile_data.set_collision_polygon_points(0, 0, PackedVector2Array([
					Vector2(-half, -half),
					Vector2(half, -half),
					Vector2(half, half),
					Vector2(-half, half),
				]))
	
	return tileset

func _paint_town() -> void:
	# Fill entire ground with grass first (with slight variation)
	var grass_tiles := [Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0),
		Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0),
		Vector2i(0, 0), Vector2i(2, 0)]
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	for y in range(30):
		for x in range(40):
			var t: Vector2i = grass_tiles[rng.randi_range(0, grass_tiles.size() - 1)]
			ground_layer.set_cell(Vector2i(x, y), 0, t)
	
	var layout_path := "res://tools/town_layout.json"
	var data: Dictionary
	if FileAccess.file_exists(layout_path):
		var file := FileAccess.open(layout_path, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
	else:
		push_warning("town_layout.json not found")
		return
	
	# Paint specific ground cells (plaza, paths) over grass
	for cell in data["ground"]:
		ground_layer.set_cell(Vector2i(cell[0], cell[1]), 0, Vector2i(cell[2], cell[3]))
	
	# Paint objects (houses, trees, fences) on upper layer
	for cell in data["objects"]:
		objects_layer.set_cell(Vector2i(cell[0], cell[1]), 0, Vector2i(cell[2], cell[3]))
	
	print("FARHOLLOW: Town painted - %d ground cells, %d object cells" % [data["ground"].size(), data["objects"].size()])
