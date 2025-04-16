extends Node

# NOTE: 34 was used for Caliburst Test, it seemed good!
const MINIMUM_WORD_COUNT = 34

var area_enum : int

var instructions : Node
var instructions_text : Node
var running_initials = ""
var initials_size = 0
var player_initials : String

var score_scene = preload("res://menus/score_screen.tscn").instantiate()


func load_level(_area_enum : int, area_dynamic_data : Dictionary):
	# Initalize variables
	area_enum = _area_enum
	
	# Load chunk with data
	$OverworldChunk.gameplay_mode = Global.WRITING_MODE
	
	# Match area specific stuffs
	match area_enum:
		WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
			$OverworldChunk.area_atlas_id = 2
			instructions = $MenusCanvasLayer/InstructionsSadness
		WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
			$OverworldChunk.area_atlas_id = 4
			instructions = $MenusCanvasLayer/InstructionsAnger
		WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
			$OverworldChunk.area_atlas_id = 3
			instructions = $MenusCanvasLayer/InstructionsFear
		WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
			$OverworldChunk.area_atlas_id = 1
			instructions = $MenusCanvasLayer/InstructionsJoy
	
	# Get init data
	var area_init_data = WorldManager.get_initalization_data(area_enum)
	
	# Set up Instructions
	instructions.get_child(0).text = area_init_data[WorldManager.Prompt]
	instructions.visible = true
	
	# Set up TypingInterface
	$CanvasLayer/TypingInterface.gameplay_mode = Global.WRITING_MODE
	$CanvasLayer/TypingInterface.area_enum = area_enum
	$CanvasLayer/TypingInterface.prompt = area_init_data[WorldManager.Prompt]
		
	# TODO: Need flow / way to pick character color before hand and pass that info to assets that need to know! 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_writing_instructions_input_event)
	SignalBus.passage_complete.connect(_thought_path_complete)
	SignalBus.update_writing_progress.connect(_update_writing_progress_bar)
	
	
func _writing_instructions_input_event(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		if initials_size < 3:
			running_initials += keystroke.capitalize() + " "
			initials_size += 1
			instructions.get_child(1).text = running_initials
	else:
		if keystroke == KeyboardInterface.Backspace:
			running_initials = ""
			initials_size = 0
			instructions.get_child(1).text = ""
		if keystroke == KeyboardInterface.Enter:
			if running_initials == "":
				self.player_initials = "Anonymous"
			else:
				self.player_initials = running_initials
			_start_writing()
			
func _start_writing():
	instructions.visible = false
	SignalBus.disconnect("player_keystroke", _writing_instructions_input_event)
	
	$CanvasLayer.visible = true
	$Player.initalize($OverworldChunk, "writing")
	$Player.visible = true
	KeyboardInterface.start_typing_session()

func _update_writing_progress_bar(progress):
	var progress_percentage = (float(progress / 5) / float(MINIMUM_WORD_COUNT)) * 100
	$CanvasLayer/HUD/GeneralProgressBar.value = progress_percentage
	
	if (progress / 5) >= MINIMUM_WORD_COUNT:
		$CanvasLayer/TypingInterface/DoneButton.modulate.a = 1
		$CanvasLayer/TypingInterface.minimum_passage_size_flag = true

func _thought_path_complete(passage : String):
	# Update World Dynamic Data
	WorldManager.update_areas_completed()
	# Change to score scene
	score_scene.load_score_screen(Global.WRITING_MODE, passage, area_enum, self.player_initials)
	Global.WORLD_NODE.add_child(score_scene)
	_close_writing_gameplay()
	

# Since score_screen will be in the same node structure, eliminate connectivity with writing gameplay
func _close_writing_gameplay():
	SignalBus.passage_complete.disconnect(_thought_path_complete)
	SignalBus.update_writing_progress.disconnect(_update_writing_progress_bar)
	
	$Player.queue_free()
	
	$CanvasLayer.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
