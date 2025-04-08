extends Node

# NOTE: 34 was used for Caliburst Test, it seemed good!
const MINIMUM_WORD_COUNT = 3

var area_enum : int

var score_scene = preload("res://menus/score_screen.tscn").instantiate()


func load_level(_area_enum : int, area_dynamic_data : Dictionary):
	# Initalize variables
	area_enum = _area_enum
	
	# Load chunk with data
	$OverworldChunk.gameplay_mode = Global.WRITING_MODE
	match area_enum:
		WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
			$OverworldChunk.area_atlas_id = 2
		WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
			$OverworldChunk.area_atlas_id = 4
		WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
			$OverworldChunk.area_atlas_id = 3
		WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
			$OverworldChunk.area_atlas_id = 1
	
	# Set up TypingInterface
	$CanvasLayer/TypingInterface.gameplay_mode = Global.WRITING_MODE
	$CanvasLayer/TypingInterface.area_enum = area_enum
	var area_init_data = WorldManager.get_initalization_data(area_enum)
	$CanvasLayer/TypingInterface.prompt = area_init_data[WorldManager.Prompt]
	
	# TODO: Need flow / way to pick character color before hand and pass that info to assets that need to know! 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.passage_complete.connect(_thought_path_complete)
	SignalBus.update_writing_progress.connect(_update_writing_progress_bar)
	
	$Player.initalize($OverworldChunk, "writing")
	
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
	score_scene.load_score_screen(Global.WRITING_MODE, passage, area_enum)
	Global.WORLD_NODE.add_child(score_scene)
	get_node("/root/Main/World/ThoughtPathWriting").queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
