extends HBoxContainer

@export var slots: Array[String]


func _ready() -> void:
	for slot in slots:
		var new_slot = Button.new()
		new_slot.pressed.connect(_slot_pressed.bind(slot))
		new_slot.text = slot

		add_child(new_slot)

func _process(delta: float) -> void:
	pass


func _slot_pressed(slot_name):
	print(slot_name)
