extends Node2D

@export var tilemap: TileMapLayer
@export var safe_area: Vector4
@export var break_modifier: float = 1.0
@export var scale_animation: float = 1.2

@export var selected_block: int = 0

@onready var break_stages = $'BreakStages'

var last_pos = Vector2(0, 0)
var break_timer = 0.0

var speed_scale = 0.0

func _ready() -> void:
	break_stages.scale = Vector2(0.0, 0.0)

func _process(delta: float) -> void:
	var tile_pos = tilemap.local_to_map(get_global_mouse_position())
	position = tilemap.map_to_local(tile_pos)

	# Handle block breaking/placing
	if Input.is_action_pressed('break'):
		self.break_block(tile_pos)
	elif Input.is_action_pressed('place'):
		self.place_block(tile_pos, selected_block)
	elif Input.is_action_just_released('break'):
		break_timer = -1.0
		break_stages.scale = Vector2(0.0, 0.0)

	# Detect mouse movement
	if last_pos == position:
		if scale > Vector2(1, 1):
			scale.x -= 0.1
			scale.y -= 0.1
	else:
		break_stages.scale = Vector2(0.0, 0.0)
		last_pos = position
		break_timer = -1.0

		scale.x = scale_animation
		scale.y = scale_animation

func place_block(tile_pos: Vector2, block: int, replace: bool = false):
	if not replace and tilemap.get_cell_tile_data(tile_pos) != null:
		return

	if position.x + 16 < safe_area.x or position.x > safe_area.z or position.y + 16 < safe_area.y or position.y > safe_area.w:
			tilemap.set_cell(tile_pos, 0, Vector2(block, 0))

func break_block(tile_pos: Vector2, instant: bool = false):
	if tilemap.get_cell_tile_data(tile_pos) == null:
		return

	var tile_break_timer = 0.0
	if not instant:
		tile_break_timer = tilemap.get_cell_tile_data(tile_pos).get_custom_data('BreakTime') * break_modifier

	if break_timer == -1.0:
		break_timer = tile_break_timer
	elif break_timer == 0.0:
		break_timer = -1.0
		tilemap.erase_cell(tile_pos)
		break_stages.scale = Vector2(0.0, 0.0)
	else:
		break_stages.scale += Vector2(1 / tile_break_timer, 1 / tile_break_timer)
		break_timer -= 1.0
