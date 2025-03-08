extends Node

var world_node : Node

var thought_writing_scene = preload("res://scenes/writing/thought_path_writing.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	world_node = get_node("/root/Main/World")  # NOTE: Hardcoded path
	$"writing-joy".grab_focus()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(get_viewport().gui_get_focus_owner())
	#if Input.is_action_just_released("ui_down"):
		#focus_neighbor_bottom = NodePath("HBoxContainer/VBoxContainer/TrainingButton")
	#if Input.is_action_just_released("ui_up"):
		#focus_neighbor_top = NodePath("HBoxContainer/VBoxContainer/VersusButton")
		#
	## P2 Menuing
	#if Input.is_action_just_released("ui_down"):
		#focus_neighbor_bottom = NodePath("HBoxContainer/VBoxContainer/TrainingButton")
	#if Input.is_action_just_released("ui_up"):
		#focus_neighbor_top = NodePath("HBoxContainer/VBoxContainer/VersusButton")


# BUG: Stage select remaining in scene is causing issues when pressing space!
func _on_writingjoy_pressed():	
	WorldManager.current_player_area = WorldManager.JOY_AREA
	thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.JOY_AREA), WorldManager.get_dynamic_data(WorldManager.JOY_AREA))
	
	# TODO: Why do we have to do this instead of change scene?
	world_node.add_child(thought_writing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()


func _on_writingsadness_pressed():
	WorldManager.current_player_area = WorldManager.SADNESS_AREA
	thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.SADNESS_AREA), WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA))
	
	world_node.add_child(thought_writing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()


func _on_save_pressed():
	SignalBus.save_game.emit()


func _on_load_pressed():
	SignalBus.load_game.emit()
