extends StaticBody2D
## FARHOLLOW - NPC
## A villager standing in town. Set sprite_texture in the editor or via setup().

@export var sprite_texture: Texture2D

func _ready() -> void:
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(10, 12)
	shape.shape = rect
	shape.position = Vector2(0, 2)
	add_child(shape)
	
	if sprite_texture:
		var sprite := Sprite2D.new()
		sprite.texture = sprite_texture
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(sprite)

func setup(tex: Texture2D, pos: Vector2) -> void:
	sprite_texture = tex
	position = pos
