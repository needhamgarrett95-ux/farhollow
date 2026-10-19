extends CharacterBody2D
## FARHOLLOW - Player Controller
## Smooth 8-direction top-down movement.

@export var speed := 100.0
@export var acceleration := 800.0
@export var friction := 1000.0

func _ready() -> void:
	# Collision shape for the player (smaller than sprite for good feel)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(10, 12)
	shape.shape = rect
	shape.position = Vector2(0, 2)
	add_child(shape)
	
	# Sprite
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/characters/player.png")
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
