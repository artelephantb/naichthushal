extends Node2D

@onready var tilemap = $'../TileMapLayer'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = tilemap.local_to_map(get_global_mouse_position()) * 16 + Vector2i(8, 8)
