extends Node

@onready var starting_overworld_chunk : OverworldChunk = $OverworldChunk

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_scene = preload("res://src/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.init("p1", starting_overworld_chunk)
	player_node.position = Vector2i(32,96)
	#$PlayerCamera.player = player_node
	
	
	SignalBus.add_player_to_chunk.emit(player_node, starting_overworld_chunk)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
