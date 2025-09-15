extends HBoxContainer

@export var slots: Array[int]
@export var selected_slot_index: int
@export var selected_item_index: int


func _ready() -> void:
	for slot_index in range(len(slots)):
		var new_slot = Button.new()
		new_slot.pressed.connect(_slot_pressed.bind(slot_index, slots[slot_index]))
		new_slot.text = str(slot_index)

		add_child(new_slot)

func _process(delta: float) -> void:
	pass


func _slot_pressed(slot_index: int, item_index: int):
	selected_slot_index = slot_index
	print(item_index)
