extends Node

var area_enum : int

var instructions_sprite : Node
var running_initials = ""
var initials_size = 0

var score_scene = preload("res://menus/score_screen.tscn").instantiate()

func load_level(_area_enum : int, area_dynamic_data : Dictionary):
	# Initalize variables
	area_enum = _area_enum

	# Load Chunks with data
	$OverworldChunk.gameplay_mode = Global.RACING_MODE
	
	match area_enum:
		WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
			$OverworldChunk.area_atlas_id = 2
			instructions_sprite = $MenusCanvasLayer/InstructionsSadness
		WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
			$OverworldChunk.area_atlas_id = 4
			instructions_sprite = $MenusCanvasLayer/InstructionsAnger
		WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
			$OverworldChunk.area_atlas_id = 3
			instructions_sprite = $MenusCanvasLayer/InstructionsFear
		WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
			$OverworldChunk.area_atlas_id = 1
			instructions_sprite = $MenusCanvasLayer/InstructionsJoy
	
	var dyanmic_area_data = WorldManager.get_dynamic_data(area_enum)
	instructions_sprite.visible = true
	instructions_sprite.get_child(0).text = dyanmic_area_data[WorldManager.CurrAreaPassageTitle]
	
	$OverworldChunk.thought_path_passage = area_dynamic_data[WorldManager.CurrAreaPassage]
	
	$CanvasLayer/TypingInterface.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterface.area_enum = area_enum
	$CanvasLayer/TypingInterface.target_passage = area_dynamic_data[WorldManager.CurrAreaPassage]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_racing_instructions_input_event)
	SignalBus.racing_complete.connect(_thought_racing_complete)
	#SignalBus.game_over.connect(_thought_racing_failed)
	SignalBus.update_racing_progress.connect(_update_racing_progress_bar)
	
	
func _racing_instructions_input_event(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		if initials_size < 3:
			running_initials += keystroke.capitalize() + " "
			initials_size += 1
			instructions_sprite.get_child(1).text = running_initials
	else:
		if keystroke == KeyboardInterface.Backspace:
			running_initials = ""
			initials_size = 0
			instructions_sprite.get_child(1).text = ""
		if keystroke == KeyboardInterface.Enter:
			if running_initials == "":
				self.running_initials = "Anonymous"
			else:
				self.running_initials = running_initials
			_start_racing()
			
			
func _start_racing():
	instructions_sprite.visible = false
	SignalBus.disconnect("player_keystroke", _racing_instructions_input_event)
	
	$CanvasLayer.visible = true
	$OverworldChunk/Player.initalize($OverworldChunk, "racing")
	$OverworldChunk/Player.visible = true
	KeyboardInterface.start_typing_session()

func _update_racing_progress_bar(progress):
	$CanvasLayer/HUD/GeneralProgressBar.value = progress
	
func _thought_racing_complete():
	SignalBus.scene_change.emit(Global.thought_path_racing, Global.score_screen, area_enum)
	$CanvasLayer/HUD.victory()
	await get_tree().create_timer(3.0).timeout
	# Change to score scene
	score_scene.load_score_screen(Global.RACING_MODE, "", area_enum, running_initials)
	Global.WORLD_NODE.add_child(score_scene)
	_close_racing_gameplay()
	
	
# Since score_screen will be in the same node structure, eliminate connectivity with racing gameplay
func _close_racing_gameplay():
	SignalBus.racing_complete.disconnect(_thought_racing_complete)
	#SignalBus.game_over.disconnect(_thought_racing_failed)
	SignalBus.update_racing_progress.disconnect(_update_racing_progress_bar)
	
	$OverworldChunk/Player.queue_free()
	
	$CanvasLayer.visible = false
	
#func _thought_racing_failed():
	## Call prior to signal displays a game over notice, so wait 3 seconds 
	#await get_tree().create_timer(3.0).timeout
	#score_scene.load_score_screen(Global.RACING_MODE, "", area_enum)
	#Global.WORLD_NODE.add_child(score_scene)
	#get_node("/root/Main/World/ThoughtPathRacing").queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
