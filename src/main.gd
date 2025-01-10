extends Node

@onready var overworld_map : OverworldLayer = $WorldNode.overworld_map

# Called when the node enters the scene tree for the first time.
func _ready():
	# Controller Connections
	#Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	pass # Replace with function body.
	var player_scene = preload("res://src/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.init("p1", overworld_map)
	player_node.position = Vector2(960, 540)
	add_child(player_node)

	$Timer.start(90)
	SignalBus.resource_collected.connect(_update_timer)

# NOTE: Timer stuff is demo code!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.time_left <= 0:
			SignalBus.endgame.emit("defeat")
	SignalBus.timer_update.emit(int($Timer.time_left))

func _update_timer():
	var current_time = $Timer.time_left
	$Timer.stop()
	$Timer.wait_time = current_time + 10
	$Timer.start()
	SignalBus.timer_update.emit(int($Timer.time_left))
