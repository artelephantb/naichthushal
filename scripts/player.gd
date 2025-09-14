extends CharacterBody2D

@export var speed = 130.0
@export var jump_velocity = -300.0

@export var selection = 0
@export var flight = false

@onready var animation = $AnimatedSprite2D
@onready var world = $".."
@onready var tilemap = $"../TileMapLayer"

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
			velocity.y = jump_velocity

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
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _process(delta: float) -> void:
	pass

func _on_grass_pressed() -> void:
	$'../BlockSelection'.selected_block = 0

func _on_cobble_pressed() -> void:
	$'../BlockSelection'.selected_block = 2

func _on_sand_pressed() -> void:
	$'../BlockSelection'.selected_block = 3

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
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path('user://maps'))
	$"../SaveMapPopup".popup_centered()

func _on_export_popup_file_selected(path: String) -> void:
	pass

func _on_dirt_pressed() -> void:
	$'../BlockSelection'.selected_block = 1

func _on_flight_pressed() -> void:
	if flight:
		flight = false
	else:
		flight = true

func _on_ice_pressed() -> void:
	$'../BlockSelection'.selected_block = 4

func _on_barrier_pressed() -> void:
	$'../BlockSelection'.selected_block = 5

func _on_instabreak_pressed() -> void:
	$'../BlockSelection'.break_modifier = 0.0
