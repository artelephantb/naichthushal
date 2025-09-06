extends Node2D

@export var tilemap: TileMapLayer
@export var safe_area: Vector4
@export var break_modifier: float = 1.0

@export var scale_animation: float = 1.2

#@onready var break_stages = $'AnimatedSprite2D'
@onready var break_stages = $'BreakStages'

var last_pos = Vector2(0, 0)
var break_timer = 0.0

var speed_scale = 0.0

func _ready() -> void:
	#break_stages.hide()
	break_stages.scale = Vector2(0.0, 0.0)

func _process(delta: float) -> void:
	var tile_pos = tilemap.local_to_map(get_global_mouse_position())
	position = tilemap.map_to_local(tile_pos)

	# Handle block breaking/placing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tilemap.get_cell_tile_data(tile_pos) != null:
			var tile_break_timer = tilemap.get_cell_tile_data(tile_pos).get_custom_data('BreakTime') * break_modifier
			if break_timer == -1.0:
				break_timer = tile_break_timer
				#break_stages.frame = 0
				#speed_scale = break_timer / 100
				#break_stages.speed_scale = break_timer / 100
				#print(break_timer / 100)
				#break_stages.play('default')
				#break_stages.show()
			elif break_timer == 0.0:
				break_timer = -1.0
				tilemap.erase_cell(tile_pos)
				break_stages.scale = Vector2(0.0, 0.0)
				#break_stages.hide()
			else:
				#break_stages.frame += speed_scale
				break_stages.scale += Vector2(1 / tile_break_timer, 1 / tile_break_timer)
				break_timer -= 1.0
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if tilemap.get_cell_tile_data(tile_pos) == null and (position.x + 16 < safe_area.x or position.x > safe_area.z or position.y + 16 < safe_area.y or position.y > safe_area.w):
			tilemap.set_cell(tile_pos, 0, Vector2(1, 0))
	elif Input.is_action_just_released('left_click'):
		break_timer = -1.0
		break_stages.scale = Vector2(0.0, 0.0)
		#break_stages.hide()

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
