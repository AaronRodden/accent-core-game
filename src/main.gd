extends Node

@onready var overworld_map : OverworldLayer = $WorldNode.overworld_map

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var player_scene = preload("res://src/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.init("p1", overworld_map)
	player_node.position = Vector2(960, 540)
	add_child(player_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
