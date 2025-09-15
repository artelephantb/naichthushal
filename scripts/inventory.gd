extends HBoxContainer

@export var main_slots: Array[int]
@export var selected_slot_index: int
@export var selected_item_index: int


func create_slots(slots: Array[int]):
	for slot_index in range(len(slots)):
		var new_slot = Button.new()
		new_slot.pressed.connect(_slot_pressed.bind(slot_index))
		new_slot.text = str(slot_index) + ' with block ' + str(slots[slot_index])

		add_child(new_slot)

func _ready() -> void:
	create_slots(main_slots)

func _process(delta: float) -> void:
	pass


func _slot_pressed(slot_index: int):
	selected_slot_index = slot_index
	selected_item_index = main_slots[slot_index]
