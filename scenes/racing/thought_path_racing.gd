extends Node

func load_level(area_init_data_a : Dictionary, area_dynamic_data_a : Dictionary,
	area_init_data_b : Dictionary, area_dynamic_data_b : Dictionary):
	# Load Chunks with data
	$OverworldChunkA.gameplay_mode = Global.RACING_MODE
	$OverworldChunkB.gameplay_mode = Global.RACING_MODE
	
	$CanvasLayer/TypingInterface.gameplay_mode = Global.RACING_MODE
	# TODO: Setup for double passage stuff!
	$CanvasLayer/TypingInterface.target_passage = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	
	$OverworldChunkA.area_atlas_id = area_init_data_a[WorldManager.AtlasID]
	$OverworldChunkB.area_atlas_id = area_init_data_b[WorldManager.AtlasID]
	
	$OverworldChunkA.thought_path_passage = area_dynamic_data_a[WorldManager.CurrAreaPassage]
	$OverworldChunkB.thought_path_passage = area_dynamic_data_b[WorldManager.CurrAreaPassage]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	$Player.initalize($OverworldChunkA, "racing")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
