extends Node

# TODO: Game Design Notes 03/14/25
# Sometimes the words <> writing a story are in conflict with each other
# Is there a way we can make it obvious how people may use the words
# We need some sort of onboarding / tutorial! 
# Timing as a part of the experience, 
# Tutorializing this in some way. 

var area_enum_a : int
var area_enum_b : int

var score_scene = preload("res://menus/score_screen.tscn").instantiate()

func load_level(area_init_data_a : Dictionary, area_dynamic_data_a : Dictionary,
	area_init_data_b : Dictionary, area_dynamic_data_b : Dictionary):
	# Initalize variables
	area_enum_a = area_init_data_a[WorldManager.AtlasID]
	area_enum_b = area_init_data_b[WorldManager.AtlasID]
	#passage_a = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	#passage_b = area_dynamic_data_b[WorldManager.CurrAreaPassage]
	#author_a = area_dynamic_data_a[WorldManager.CurrAreaPassageAuthor]
	#author_b = area_dynamic_data_b[WorldManger.Curr]
	#
	# Load Chunks with data
	$OverworldChunkA.gameplay_mode = Global.RACING_MODE
	$OverworldChunkB.gameplay_mode = Global.RACING_MODE
	
	$OverworldChunkA.area_atlas_id = area_enum_a
	$OverworldChunkB.area_atlas_id = area_enum_b
	$OverworldChunkA.thought_path_passage = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	$OverworldChunkB.thought_path_passage = area_dynamic_data_b[WorldManager.CurrAreaPassage]
	
	$CanvasLayer/TypingInterfaceA.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterfaceA.target_passage = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	$CanvasLayer/TypingInterfaceB.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterfaceB.target_passage = area_dynamic_data_b[WorldManager.CurrAreaPassage]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.racing_complete.connect(_thought_racing_complete)
	SignalBus.game_over.connect(_thought_racing_failed)
	
	# Initalize Objects dependent on OverworldChunk Creation
	# TODO: Should Player be a child of OverworldChunk in writing gameplay as well?
	$OverworldChunkA/PlayerA.initalize($OverworldChunkA, "racing")
	$OverworldChunkB/PlayerB.initalize($OverworldChunkB, "racing")
	$OverworldChunkB/PlayerB.lock()

	$OverworldChunkA/ObjectSpawnerA.initalize($OverworldChunkA)
	$OverworldChunkB/ObjectSpawnerB.initalize($OverworldChunkB)
	
	# TOOD: Should the session start here or on first key pressed?
	KeyboardInterface.start_typing_session()
	
func _thought_racing_complete():
	$CanvasLayer/HUD.victory()
	await get_tree().create_timer(3.0).timeout
	# Change to score scene
	score_scene.load_score_screen(Global.RACING_MODE, "", area_enum_a, area_enum_b)
	Global.WORLD_NODE.add_child(score_scene)
	get_node("/root/Main/World/ThoughtPathRacing").queue_free()
	
func _thought_racing_failed():
	# Call prior to signal displays a game over notice, so wait 3 seconds 
	await get_tree().create_timer(3.0).timeout
	score_scene.load_score_screen(Global.RACING_MODE, "", area_enum_a, area_enum_b)
	Global.WORLD_NODE.add_child(score_scene)
	get_node("/root/Main/World/ThoughtPathRacing").queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
