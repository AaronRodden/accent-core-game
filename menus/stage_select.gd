extends Node

var world_node : Node

var thought_writing_scene = preload("res://scenes/writing/thought_path_writing.tscn").instantiate()
var thought_racing_scene = preload("res://scenes/racing/thought_path_racing.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Grab World Node again before moving between game scenes
	Global.WORLD_NODE = get_node("/root/Main/World")  # NOTE: Hardcoded path
	$"writing-joy".grab_focus()
	
	$VersionNumberDisplay.text = Global.VERSION_NUMBER


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# BUG: Stage select remaining in scene is causing issues when pressing space!
func _on_writingjoy_pressed():
	WorldManager.current_player_area = WorldManager.JOY_AREA
	thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.JOY_AREA), WorldManager.get_dynamic_data(WorldManager.JOY_AREA))
	
	# TODO: Why do we have to do this instead of change scene?
	Global.WORLD_NODE.add_child(thought_writing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.JOY_AREA)


func _on_writingsadness_pressed():
	WorldManager.current_player_area = WorldManager.SADNESS_AREA
	thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.SADNESS_AREA), WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA))
	
	Global.WORLD_NODE.add_child(thought_writing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.SADNESS_AREA)


func _on_save_pressed():
	SignalBus.save_game.emit()


func _on_load_pressed():
	SignalBus.load_game.emit()


func _on_racingjoy_pressed():
	var previous_area = WorldManager.current_player_area
	# DEBUG: Default to previous area Sadness
	previous_area = WorldManager.SADNESS_AREA
	WorldManager.current_player_area = WorldManager.JOY_AREA
	
	thought_racing_scene.load_level(
		WorldManager.get_initalization_data(WorldManager.JOY_AREA), WorldManager.get_dynamic_data(WorldManager.JOY_AREA),
		WorldManager.get_initalization_data(previous_area), WorldManager.get_dynamic_data(previous_area))
	
	Global.WORLD_NODE.add_child(thought_racing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.JOY_AREA)


func _on_racingsadness_pressed():
	var previous_area = WorldManager.current_player_area
	# DEBUG: Default to previous area Joy
	previous_area = WorldManager.JOY_AREA
	WorldManager.current_player_area = WorldManager.SADNESS_AREA
	
	thought_racing_scene.load_level(
		WorldManager.get_initalization_data(WorldManager.SADNESS_AREA), WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA),
		WorldManager.get_initalization_data(previous_area), WorldManager.get_dynamic_data(previous_area))
		
	Global.WORLD_NODE.add_child(thought_racing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.SADNESS_AREA)


func _on_writingfear_pressed():
	WorldManager.current_player_area = WorldManager.FEAR_AREA
	thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.FEAR_AREA), WorldManager.get_dynamic_data(WorldManager.FEAR_AREA))
	
	Global.WORLD_NODE.add_child(thought_writing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.FEAR_AREA)
	
func _on_writinganger_pressed():
	WorldManager.current_player_area = WorldManager.ANGER_AREA
	thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.ANGER_AREA), WorldManager.get_dynamic_data(WorldManager.ANGER_AREA))
	
	Global.WORLD_NODE.add_child(thought_writing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.ANGER_AREA)


func _on_racingfear_pressed():
	var previous_area = WorldManager.current_player_area
	# DEBUG: Default to previous area Joy
	previous_area = WorldManager.JOY_AREA
	WorldManager.current_player_area = WorldManager.FEAR_AREA
	
	thought_racing_scene.load_level(
		WorldManager.get_initalization_data(WorldManager.FEAR_AREA), WorldManager.get_dynamic_data(WorldManager.FEAR_AREA),
		WorldManager.get_initalization_data(previous_area), WorldManager.get_dynamic_data(previous_area))
		
	Global.WORLD_NODE.add_child(thought_racing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.FEAR_AREA)


func _on_racinganger_pressed():
	var previous_area = WorldManager.current_player_area
	# DEBUG: Default to previous area Joy
	previous_area = WorldManager.FEAR_AREA
	WorldManager.current_player_area = WorldManager.ANGER_AREA
	
	thought_racing_scene.load_level(
		WorldManager.get_initalization_data(WorldManager.ANGER_AREA), WorldManager.get_dynamic_data(WorldManager.ANGER_AREA),
		WorldManager.get_initalization_data(previous_area), WorldManager.get_dynamic_data(previous_area))
		
	Global.WORLD_NODE.add_child(thought_racing_scene)
	get_node("/root/Main/World/StageSelect").queue_free()
	SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.ANGER_AREA)
