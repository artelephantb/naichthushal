extends Popup

signal cancel_pressed
signal save_pressed

@export var background_color: Color = '#404040'
@export var save_location: String

@onready var background = $'Background'
@onready var name_input = $'NameInput'


func _ready() -> void:
	background.color = background_color


func _on_cancel_pressed() -> void:
	emit_signal('cancel_pressed')

func _on_save_pressed() -> void:
	emit_signal('save_pressed', name_input.text)
