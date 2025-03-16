extends Node

# TODO: Game Design Notes 03/14/25
# Sometimes the words <> writing a story are in conflict with each other
# Is there a way we can make it obvious how people may use the words
# We need some sort of onboarding / tutorial! 
# Timing as a part of the experience, 
# Tutorializing this in some way. 

func load_level(area_init_data_a : Dictionary, area_dynamic_data_a : Dictionary,
	area_init_data_b : Dictionary, area_dynamic_data_b : Dictionary):
	# Load Chunks with data
	$OverworldChunkA.gameplay_mode = Global.RACING_MODE
	$OverworldChunkB.gameplay_mode = Global.RACING_MODE
	
	$OverworldChunkA.area_atlas_id = area_init_data_a[WorldManager.AtlasID]
	$OverworldChunkB.area_atlas_id = area_init_data_b[WorldManager.AtlasID]
	$OverworldChunkA.thought_path_passage = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	$OverworldChunkB.thought_path_passage = area_dynamic_data_b[WorldManager.CurrAreaPassage]
	
	$CanvasLayer/TypingInterfaceA.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterfaceA.target_passage = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	$CanvasLayer/TypingInterfaceB.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterfaceB.target_passage = area_dynamic_data_b[WorldManager.CurrAreaPassage]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initalize Objects dependent on OverworldChunk Creation
	# TODO: Should Player be a child of OverworldChunk in writing gameplay as well?
	$OverworldChunkA/PlayerA.initalize($OverworldChunkA, "racing")
	$OverworldChunkB/PlayerB.initalize($OverworldChunkB, "racing")
	$OverworldChunkB/PlayerB.lock()

	$OverworldChunkA/ObjectSpawnerA.initalize($OverworldChunkA)
	$OverworldChunkB/ObjectSpawnerB.initalize($OverworldChunkB)
	
	# TOOD: Should the session start here or on first key pressed?
	KeyboardInterface.start_typing_session()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
