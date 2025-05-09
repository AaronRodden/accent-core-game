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
	
	$VersionNumberDisplay.text = Global.VERSION_NUMBER
	
	# Render stage select according to dynamic data
	_update_stage_select()
	_update_title_box(current_selector, 1)
	
	$NeuronCursor.position = current_selector.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down"):
		selector_number -= 1
		selector_number = clamp(selector_number, 1, self.areas_completed + 1)
		var next_selector_node = "Selector" + str(selector_number)
		current_selector = get_node(next_selector_node)
		$NeuronCursor.position = current_selector.position
		_update_title_box(current_selector, selector_number)

	if Input.is_action_just_pressed("up"):
		selector_number += 1
		selector_number = clamp(selector_number, 1, self.areas_completed + 1)  # First clamp between 1 and areas complete
		selector_number = clamp(selector_number, 1, 12)  # Them clamp between 1 and 12 for completed games
		var next_selector_node = "Selector" + str(selector_number)
		current_selector = get_node(next_selector_node)
		$NeuronCursor.position = current_selector.position
		_update_title_box(current_selector, selector_number)
		

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
	var updated_areas_completed = WorldManager.get_world_data()["areas_completed"]
	if updated_areas_completed == 0:
		var incomplete_path_str = "Path" + str(1) + "Incomplete"
		var incomplete_path_node = get_node(incomplete_path_str)
		incomplete_path_node.visible = true
		
		var selector_node = get_node(("Selector" + str(1)))
		selector_node.visible = true
		# Play blink animation given 1st passage has not been written
		selector_node.get_child(0).play("blink")
	else:
		for level in range(1, updated_areas_completed+1):
			if level == 12:
				continue
			var complete_path_str = "Path" + str(level) + "Complete"
			var complete_path_node = get_node(complete_path_str)
			complete_path_node.visible = true
			
			var incomplete_path_str = "Path" + str(level) + "Incomplete"
			var incomplete_path_node = get_node(incomplete_path_str)
			incomplete_path_node.visible = false
			
			var selector_node = get_node(("Selector" + str(level)))
			selector_node.visible = true
			
			# Turn off existing blink animations, needed for proper file loading
			selector_node.get_child(0).stop()
			
		if updated_areas_completed == 12:
			var selector_node = get_node(("Selector" + str(updated_areas_completed)))
			selector_node.visible = true
		else:
			var selector_node = get_node(("Selector" + str(updated_areas_completed + 1)))
			selector_node.visible = true
			selector_node.get_child(0).play("blink")  # Play blink animation for farthest node
			
	self.areas_completed = updated_areas_completed
	$GeneralProgressBar.value = float(self.areas_completed)/12.0 * 100.0
	
	if areas_completed > 0:
		$ArrowKeyInfoBox.visible = true
		$ArrowKeyInfoText.visible = true
		$ArrowKeyUpTip.visible = true
		$ArrowKeyDownTip.visible = true
	
	_update_world_data_text()
	
func _update_title_box(current_selector: Node, area_selector: int):
	$TitleBox.position = Vector2(current_selector.position.x - 250, current_selector.position.y)
	if area_selector > self.areas_completed:
		$TitleBox/TitleText.text = "[center][wave]" + "No passage here yet!\nWrite a new one!"
	else:
		var dynamic_area_data = WorldManager.get_dynamic_data(area_selector)
		var area_passage_title = dynamic_area_data[WorldManager.CurrAreaPassageTitle]
		var area_passage_author = dynamic_area_data[WorldManager.CurrAreaPassageAuthor]
		$TitleBox/TitleText.text = "[center][wave]" + area_passage_title + "\n" + "By: " + area_passage_author
	
func _update_world_data_text(session_dict = null):
	# Update player count
	var player_count = WorldManager.get_world_data(WorldManager.PlayerCount)
	$PlayerCount.text = str(player_count) + " players played today"
	# Update play feed
	var play_history_list = WorldManager.get_world_data(WorldManager.PlayHistory)
	for play_feed_string in play_history_list:
		if not $GameHistory.text.contains(play_feed_string):
			$GameHistory.text += play_feed_string + "\n"
			
	SignalBus.save_game.emit()

func _on_save_pressed():
	SignalBus.save_game.emit()


func _on_load_pressed():
	SignalBus.load_game.emit()
	
