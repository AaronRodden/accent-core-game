extends Node

# TODO: Game Design Notes 03/14/25
# Sometimes the words <> writing a story are in conflict with each other
# Is there a way we can make it obvious how people may use the words
# We need some sort of onboarding / tutorial! 
# Timing as a part of the experience, 
# Tutorializing this in some way. 

var area_enum : int

var score_scene = preload("res://menus/score_screen.tscn").instantiate()

func load_level(area_init_data : Dictionary, area_dynamic_data : Dictionary):
	# Initalize variables
	area_enum = area_init_data[WorldManager.AtlasID]

	# Load Chunks with data
	$OverworldChunk.gameplay_mode = Global.RACING_MODE
	
	$OverworldChunk.area_atlas_id = area_enum
	$OverworldChunk.thought_path_passage = area_dynamic_data[WorldManager.CurrAreaPassage]
	
	$CanvasLayer/TypingInterface.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterface.target_passage = area_dynamic_data[WorldManager.CurrAreaPassage]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.racing_complete.connect(_thought_racing_complete)
	SignalBus.game_over.connect(_thought_racing_failed)
	SignalBus.update_racing_progress.connect(_update_racing_progress_bar)
	
	# Initalize Objects dependent on OverworldChunk Creation
	# TODO: Should Player be a child of OverworldChunk in writing gameplay as well?
	$OverworldChunk/Player.initalize($OverworldChunk, "racing")

	# TOOD: Should the session start here or on first key pressed?
	KeyboardInterface.start_typing_session()

func _update_racing_progress_bar(progress):
	$CanvasLayer/HUD/GeneralProgressBar.value = progress
	
func _thought_racing_complete():
	$CanvasLayer/HUD.victory()
	await get_tree().create_timer(3.0).timeout
	# Change to score scene
	score_scene.load_score_screen(Global.RACING_MODE, "", area_enum)
	Global.WORLD_NODE.add_child(score_scene)
	get_node("/root/Main/World/ThoughtPathRacing").queue_free()
	
func _thought_racing_failed():
	# Call prior to signal displays a game over notice, so wait 3 seconds 
	await get_tree().create_timer(3.0).timeout
	score_scene.load_score_screen(Global.RACING_MODE, "", area_enum)
	Global.WORLD_NODE.add_child(score_scene)
	get_node("/root/Main/World/ThoughtPathRacing").queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
