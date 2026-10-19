extends Node2D
## FARHOLLOW - Main Scene
## Sets up input, spawns player and NPCs, configures camera.

const PlayerScript := preload("res://scripts/player.gd")
const NPCScript := preload("res://scripts/npc.gd")
const TownBuilder := preload("res://scripts/town_builder.gd")

# NPC placements (tile coords -> pixel pos)
const NPC_DATA := [
	{"tex": "res://assets/characters/npc_elder.png", "tile": Vector2i(16, 12)},  # Near plaza
	{"tex": "res://assets/characters/npc_smith.png", "tile": Vector2i(24, 12)},  # Near plaza
	{"tex": "res://assets/characters/npc_girl.png", "tile": Vector2i(6, 10)},    # Near NW house
]

func _ready() -> void:
	_setup_input()
	
	# Build the town
	var town := Node2D.new()
	town.set_script(TownBuilder)
	town.name = "Town"
	add_child(town)
	
	# Spawn player at plaza entrance (tile 20,18 -> pixel center)
	var player := CharacterBody2D.new()
	player.set_script(PlayerScript)
	player.name = "Player"
	player.position = Vector2(20 * 16 + 8, 18 * 16 + 8)
	add_child(player)
	
	# Camera follows player
	var camera := Camera2D.new()
	camera.name = "Camera"
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	camera.zoom = Vector2(3, 3)  # 3x zoom for chunky pixels at 480x270
	player.add_child(camera)
	camera.make_current()
	
	# Spawn NPCs
	for npc_info in NPC_DATA:
		var npc := StaticBody2D.new()
		npc.set_script(NPCScript)
		var tex: Texture2D = load(npc_info["tex"])
		var tile: Vector2i = npc_info["tile"]
		# Use setup method if available, else set directly
		npc.set("sprite_texture", tex)
		npc.position = Vector2(tile.x * 16 + 8, tile.y * 16 + 8)
		add_child(npc)
	
	print("FARHOLLOW: Main scene ready")

func _setup_input() -> void:
	# Define movement actions if they don't exist
	_add_key_action("move_left", [KEY_A, KEY_LEFT])
	_add_key_action("move_right", [KEY_D, KEY_RIGHT])
	_add_key_action("move_up", [KEY_W, KEY_UP])
	_add_key_action("move_down", [KEY_S, KEY_DOWN])

func _add_key_action(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		# Avoid duplicates
		var exists := false
		for e in InputMap.action_get_events(action):
			if e is InputEventKey and e.physical_keycode == key:
				exists = true
				break
		if not exists:
			InputMap.action_add_event(action, event)
