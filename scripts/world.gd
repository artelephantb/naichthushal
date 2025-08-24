extends Node

const BLOCKS = [{'title':'Test', 'name':'test', 'texture':Vector2i(0, 0), 'break_time':10}]

@onready var tile_layer = $TileMapLayer

func etch_block(name: String, title: String, texture: Vector2i, break_time: float):
	BLOCKS.append({'name':name, 'title':title, 'texture':texture, 'break_time':break_time})

func set_block_tiles(blocks: Array):
	var tile_set = TileSet.new()

	for block in range(len(blocks)):
		var atlas = TileSetAtlasSource.new()
		atlas.texture = load(blocks[block])
		atlas.create_tile(Vector2i(0, 0))

		tile_set.add_source(atlas, block)

	tile_layer.tile_set = tile_set

func _ready() -> void:
	get_window().files_dropped.connect(_on_world_import)
	#set_block_tiles(['res://assets/textures/blocks/cobble.png', 'res://assets/textures/blocks/grass.png', 'res://assets/textures/blocks/sand.png'])
	$TileMapLayer.material.set('shader_parameter/blackout', 0)

func _process(delta: float) -> void:
	if not $AudioStreamPlayer.playing and randi_range(0, 50000) == 0:
		$AudioStreamPlayer.play(0)
	if $TileMapLayer.material.get('shader_parameter/blackout') < 1:
		$TileMapLayer.material.set('shader_parameter/blackout', $TileMapLayer.material.get('shader_parameter/blackout') + 0.01)

func _notification(what: int) -> void:
	if what == NOTIFICATION_CRASH:
		print('Crashed')
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:
		print('Closed')

func _on_world_import(path: Array) -> void:
	var file = FileAccess.open(path[0], FileAccess.READ)
	var content = file.get_as_text()

	if content and content:
		tile_layer.tile_map_data = str_to_var(content)
	else:
		printerr('Invalid world')
		tile_layer.tile_map_data = []
