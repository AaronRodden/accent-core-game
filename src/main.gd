extends Node

@onready var starting_overworld_chunk : OverworldChunk = $WorldNode/OverworldChunkOutskirts1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and connections
	#SignalBus.resource_collected.connect(_update_timer)
	SignalBus.health_tile_event.connect(_update_timer)
	
	var player_scene = preload("res://src/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.init("p1", starting_overworld_chunk)
	player_node.position = $WorldNode.to_local(starting_overworld_chunk.current_player_position)
	#player_node.position = $WorldNode.to_local(starting_overworld_chunk.overworld_map.OverworldInputMapping.keys()[0])
	#$PlayerCamera.offset = starting_overworld_chunk.position
	$PlayerCamera.player = player_node
	#player_node.add_child($PlayerCamera)
	
	# TODO: Figure out camera movement for different starting positions, important for debugging
	#DEBUG
	#player_node.position = $WorldNode.to_local(starting_overworld_chunk.overworld_map.map_to_local(Vector2(1,8))) # left side
	#player_node.position = $WorldNode.to_local(starting_overworld_chunk.overworld_map.map_to_local(Vector2(28,8))) # right side
	
	SignalBus.add_player_to_chunk.emit(player_node, starting_overworld_chunk)

	$Timer.start(1000)

# NOTE: Timer stuff is demo code!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.time_left <= 0:
			SignalBus.endgame.emit("defeat")
	SignalBus.timer_update.emit(int($Timer.time_left))

func _update_timer():
	var current_time = $Timer.time_left
	$Timer.stop()
	$Timer.wait_time = current_time + 30
	$Timer.start()
	SignalBus.timer_update.emit(int($Timer.time_left))
	SignalBus.resource_update.emit()
