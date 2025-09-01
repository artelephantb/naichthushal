extends Node2D

@export var scale_animation: float = 1.2

@export var tilemap: TileMapLayer

var last_pos = Vector2i(0, 0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var latest_pos = tilemap.local_to_map(get_global_mouse_position()) * 16 + Vector2i(8, 8)
	if last_pos == latest_pos:
		if scale > Vector2(1, 1):
			scale.x -= 0.1
			scale.y -= 0.1
	else:
		last_pos = latest_pos
		position = latest_pos

		scale.x = scale_animation
		scale.y = scale_animation
