extends Node2D

@export var tilemap: TileMapLayer
@export var break_modifier: float = 1.0

@export var scale_animation: float = 1.2

var last_pos = Vector2(0, 0)
var break_timer = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var tile_pos = tilemap.local_to_map(get_global_mouse_position())
	position = tilemap.map_to_local(tile_pos)

	# Handle block breaking
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tilemap.get_cell_tile_data(tile_pos) != null:
			if break_timer == -1.0:
				break_timer = tilemap.get_cell_tile_data(tile_pos).get_custom_data('BreakTime') * break_modifier
			elif break_timer == 0.0:
				break_timer = -1.0
				tilemap.erase_cell(tile_pos)
			else:
				break_timer -= 1.0
	else:
		break_timer = -1.0

	# Detect mouse movement
	if last_pos == position:
		if scale > Vector2(1, 1):
			scale.x -= 0.1
			scale.y -= 0.1
	else:
		last_pos = position
		break_timer = -1.0

		scale.x = scale_animation
		scale.y = scale_animation
