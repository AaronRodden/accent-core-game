extends Node

var world_node : Node

var thought_writing_scene = preload("res://scenes/writing/thought_path_writing.tscn").instantiate()
var thought_racing_scene = preload("res://scenes/racing/thought_path_racing.tscn").instantiate()

@onready var current_selector = $Selector1
var areas_completed = 0
var selector_number = 1
var selector_max = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_level_select)
	SignalBus.load_update.connect(_update_stage_select)
	SignalBus.save_session.connect(_update_world_data_text)
	
	# Grab World Node again before moving between game scenes
	Global.WORLD_NODE = get_node("/root/Main/World")  # NOTE: Hardcoded path
	$"writing-joy".grab_focus()
	
	$VersionNumberDisplay.text = Global.VERSION_NUMBER
	
	# Render stage select according to dynamic data
	_update_stage_select()
	
	current_selector.modulate.a = 119

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down"):
		selector_number -= 1
		selector_number = clamp(selector_number, 1, self.areas_completed + 1)
		current_selector.modulate.a = 0.5
		var next_selector_node = "Selector" + str(selector_number)
		current_selector = get_node(next_selector_node)
		current_selector.modulate.a = 1
		$NeuronCursor.position = current_selector.position

	if Input.is_action_just_pressed("up"):
		selector_number += 1
		selector_number = clamp(selector_number, 1, self.areas_completed + 1)
		current_selector.modulate.a = 0.5
		var next_selector_node = "Selector" + str(selector_number)
		current_selector = get_node(next_selector_node)
		current_selector.modulate.a = 1
		$NeuronCursor.position = current_selector.position

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var keystroke = KeyboardInterface.handle_input_event(event)
		
		
func _level_select(event : InputEventKey, keystroke: String, total_keystrokes: int):
	# NOTE: Very sneaky debug keys
	if keystroke == "M":
		$save.visible = !($save.visible)
		$load.visible = !($load.visible)
	if keystroke == "S":
		$save.emit_signal("pressed")
	if keystroke == "L":
		$load.emit_signal("pressed")
	
	if keystroke != KeyboardInterface.Enter:
		return
		
	var writing_flag = false
	var racing_flag = false

	# TODO: Perhaps after matching here can pass everything via signal & parameters to avoid more match functions
	match selector_number:
		1:
			WorldManager.current_player_area = WorldManager.SADNESS_AREA_A
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA_A)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.SADNESS_AREA_A, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.SADNESS_AREA_A, area_dynamic_data)
		2:
			WorldManager.current_player_area = WorldManager.SADNESS_AREA_B
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA_B)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.SADNESS_AREA_B, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.SADNESS_AREA_B, area_dynamic_data)
		3:
			WorldManager.current_player_area =  WorldManager.SADNESS_AREA_C
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA_C)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.SADNESS_AREA_C, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.SADNESS_AREA_C, area_dynamic_data)
		4:
			WorldManager.current_player_area = WorldManager.ANGER_AREA_A
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.ANGER_AREA_A)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.ANGER_AREA_A, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.ANGER_AREA_A, area_dynamic_data)
		5:
			WorldManager.current_player_area = WorldManager.ANGER_AREA_B
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.ANGER_AREA_B)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.ANGER_AREA_B, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.ANGER_AREA_B, area_dynamic_data)
		6:
			WorldManager.current_player_area = WorldManager.ANGER_AREA_C
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.ANGER_AREA_C)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.ANGER_AREA_C, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.ANGER_AREA_C, area_dynamic_data)
		7:
			WorldManager.current_player_area = WorldManager.FEAR_AREA_A
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.FEAR_AREA_A)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.FEAR_AREA_A, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.FEAR_AREA_A, area_dynamic_data)
		8:
			WorldManager.current_player_area = WorldManager.FEAR_AREA_B
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.FEAR_AREA_B)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.FEAR_AREA_B, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.FEAR_AREA_B, area_dynamic_data)
		9:
			WorldManager.current_player_area = WorldManager.FEAR_AREA_C
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.FEAR_AREA_C)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.FEAR_AREA_C, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.FEAR_AREA_C, area_dynamic_data)
		10:
			WorldManager.current_player_area = WorldManager.JOY_AREA_A
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.JOY_AREA_A)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.JOY_AREA_A, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.JOY_AREA_A, area_dynamic_data)
		11:
			WorldManager.current_player_area = WorldManager.JOY_AREA_B
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.JOY_AREA_B)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.JOY_AREA_B, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.JOY_AREA_B, area_dynamic_data)
		12:
			WorldManager.current_player_area = WorldManager.JOY_AREA_C
			var area_dynamic_data = WorldManager.get_dynamic_data(WorldManager.JOY_AREA_C)
			if area_dynamic_data[WorldManager.CurrAreaPassage] == null:  # If no passage present, then writing
				writing_flag = true
				thought_writing_scene.load_level(WorldManager.JOY_AREA_C, area_dynamic_data)
			else:  # If passage is present, then racing
				racing_flag = true
				thought_racing_scene.load_level(WorldManager.JOY_AREA_C, area_dynamic_data)
			
		
	if not SessionManager.active_session:
		SessionManager.start_session()
		
	if writing_flag == true:
		SceneTransition.change_scene(thought_writing_scene)
		SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.current_player_area)
	elif racing_flag == true:
		SceneTransition.change_scene(thought_racing_scene)
		SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.current_player_area)

# Step through each area, rendering and updating the path ahead 
func _update_stage_select():
	var areas_completed = WorldManager.get_world_data()["areas_completed"]
	if areas_completed == 0:
		var incomplete_path_str = "Path" + str(1) + "Incomplete"
		var incomplete_path_node = get_node(incomplete_path_str)
		incomplete_path_node.visible = true
		
		var selector_node = get_node(("Selector" + str(1)))
		selector_node.visible = true
	else:
		for level in range(1, areas_completed+1):
			if level == 12:
				continue
			var complete_path_str = "Path" + str(level) + "Complete"
			var complete_path_node = get_node(complete_path_str)
			complete_path_node.visible = true
			
			var selector_node = get_node(("Selector" + str(level)))
			selector_node.visible = true
		
			if areas_completed <= 11:
				var incomplete_path_str = "Path" + str(areas_completed + 1) + "Incomplete"
				var incomplete_path_node = get_node(incomplete_path_str)
				incomplete_path_node.visible = true
		
		if areas_completed == 12:
			var selector_node = get_node(("Selector" + str(areas_completed)))
			selector_node.visible = true
		else:
			var selector_node = get_node(("Selector" + str(areas_completed + 1)))
			selector_node.visible = true
			
	self.areas_completed = areas_completed
	$GeneralProgressBar.value = float(self.areas_completed)/12.0 * 100.0
	
	# NOTE: Demo Code?
	if areas_completed > 0:
		$ArrowKeyInfoBox.visible = true
		$ArrowKeyInfoText.visible = true
		$ArrowKeyUpTip.visible = true
		$ArrowKeyDownTip.visible = true
	
	_update_world_data_text()
	
func _update_world_data_text(session_dict = null):
	# Update player count
	var player_count = WorldManager.get_world_data(WorldManager.PlayerCount)
	$PlayerCount.text = str(player_count) + " players today"
	# Update play feed
	var play_history_list = WorldManager.get_world_data(WorldManager.PlayHistory)
	for play_feed_string in play_history_list:
		if not $GameHistory.text.contains(play_feed_string):
			$GameHistory.text += play_feed_string + "\n"

#func _on_writingjoy_pressed():
	#WorldManager.current_player_area = WorldManager.JOY_AREA
	#thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.JOY_AREA), WorldManager.get_dynamic_data(WorldManager.JOY_AREA))
	#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_writing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.JOY_AREA)
#
#
#func _on_writingsadness_pressed():
	#WorldManager.current_player_area = WorldManager.SADNESS_AREA
	#thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.SADNESS_AREA), WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA))
	#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_writing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.SADNESS_AREA)


func _on_save_pressed():
	SignalBus.save_game.emit()


func _on_load_pressed():
	SignalBus.load_game.emit()


#func _on_racingjoy_pressed():
	#var previous_area = WorldManager.current_player_area
	## DEBUG: Default to previous area Sadness
	#WorldManager.current_player_area = WorldManager.JOY_AREA
	#
	#thought_racing_scene.load_level(
		#WorldManager.get_initalization_data(WorldManager.JOY_AREA), WorldManager.get_dynamic_data(WorldManager.JOY_AREA))
	#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_racing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.JOY_AREA)
#
#
#func _on_racingsadness_pressed():
	#var previous_area = WorldManager.current_player_area
	#WorldManager.current_player_area = WorldManager.SADNESS_AREA
	#
	#thought_racing_scene.load_level(
		#WorldManager.get_initalization_data(WorldManager.SADNESS_AREA), WorldManager.get_dynamic_data(WorldManager.SADNESS_AREA))
		#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_racing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.SADNESS_AREA)
#
#
#func _on_writingfear_pressed():
	#WorldManager.current_player_area = WorldManager.FEAR_AREA
	#thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.FEAR_AREA), WorldManager.get_dynamic_data(WorldManager.FEAR_AREA))
	#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_writing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.FEAR_AREA)
	#
#func _on_writinganger_pressed():
	#WorldManager.current_player_area = WorldManager.ANGER_AREA
	#thought_writing_scene.load_level(WorldManager.get_initalization_data(WorldManager.ANGER_AREA), WorldManager.get_dynamic_data(WorldManager.ANGER_AREA))
	#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_writing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_writing, WorldManager.ANGER_AREA)
#
#
#func _on_racingfear_pressed():
	#var previous_area = WorldManager.current_player_area
	#WorldManager.current_player_area = WorldManager.FEAR_AREA
	#
	#thought_racing_scene.load_level(
		#WorldManager.get_initalization_data(WorldManager.FEAR_AREA), WorldManager.get_dynamic_data(WorldManager.FEAR_AREA))
		#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_racing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.FEAR_AREA)
#
#
#func _on_racinganger_pressed():
	#var previous_area = WorldManager.current_player_area
	#WorldManager.current_player_area = WorldManager.ANGER_AREA
	#
	#thought_racing_scene.load_level(
		#WorldManager.get_initalization_data(WorldManager.ANGER_AREA), WorldManager.get_dynamic_data(WorldManager.ANGER_AREA))
		#
	#if not SessionManager.active_session:
		#SessionManager.start_session()
	#Global.WORLD_NODE.add_child(thought_racing_scene)
	#get_node("/root/Main/World/StageSelect").queue_free()
	#SignalBus.scene_change.emit(Global.stage_select, Global.thought_path_racing, WorldManager.ANGER_AREA)
