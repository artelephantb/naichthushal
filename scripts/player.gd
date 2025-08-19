extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animation = $AnimatedSprite2D
@onready var world = $".."
@onready var tilemap = $"../TileMapLayer"

var selection = 0
var break_time = -1
var flight = false
var instabreak = false

var last_cursor_frame = Vector2i(0, 0)

func _ready() -> void:
	var gradient_colors = {
		0.2: Color(0.4, 0.4, 0.4) * Color(randf(), randf(), randf()),
		1: Color(1, 1, 1)
	}
	var gradient_texture = GradientTexture1D.new()
	var gradient = Gradient.new()

	gradient.offsets = gradient_colors.keys()
	gradient.colors = gradient_colors.values()
	
	gradient_texture.gradient = gradient

	$AnimatedSprite2D.material.set('shader_parameter/gradient', gradient_texture)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed('player_jump'):
		if is_on_floor() or flight:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis('player_left', 'player_right')

	# Change direction
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false

	# Show animation
	if is_on_floor():
		if direction == 0:
			animation.play('idle')
		elif is_on_wall():
			animation.play('idle')
		else:
			animation.play('walk')
	else:
		animation.play('jump')

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if instabreak == true:
		break_time = 0
	var tile_pos = tilemap.local_to_map(get_global_mouse_position())
	if last_cursor_frame != tile_pos:
		last_cursor_frame = tile_pos
		break_time = -1
	$"../CanvasLayer/BreakTime".text = str(break_time)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if break_time == -1:
			if tilemap.get_cell_tile_data(tile_pos) != null:
				break_time = tilemap.get_cell_tile_data(tile_pos).get_custom_data('BreakTime')
		if break_time == 0:
			tilemap.erase_cell(tile_pos)
			break_time = -1
		elif break_time != -1:
			break_time -= 1
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): 
		tile_pos = tilemap.local_to_map(get_global_mouse_position())
		if abs(position.x - get_global_mouse_position().x) + abs(position.y - get_global_mouse_position().y) > 30:
			tilemap.set_cell(tile_pos, 0, Vector2(selection, 0))
	else:
		break_time = -1

func _on_grass_pressed() -> void:
	selection = 0

func _on_cobble_pressed() -> void:
	selection = 2

func _on_sand_pressed() -> void:
	selection = 3

func _on_import_pressed() -> void:
	$"../ImportPopup".popup()

func _on_import_popup_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()

	if content:
		tilemap.tile_map_data = str_to_var(content)
	else:
		printerr('Invalid world')
		tilemap.tile_map_data = []

func _on_export_pressed() -> void:
	get_viewport().gui_get_focus_owner().release_focus()
	$"../ExportPopup".popup()

func _on_export_popup_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(str(tilemap.tile_map_data))

func _on_dirt_pressed() -> void:
	selection = 1

func _on_flight_pressed() -> void:
	if flight:
		flight = false
	else:
		flight = true

func _on_ice_pressed() -> void:
	selection = 4

func _on_barrier_pressed() -> void:
	selection = 5

func _on_instabreak_pressed() -> void:
	instabreak = true
