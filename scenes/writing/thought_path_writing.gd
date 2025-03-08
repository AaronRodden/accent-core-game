extends Node

var area_enum : int

func load_level(area_init_data : Dictionary, area_dynamic_data : Dictionary):
	# Initalize variables
	area_enum = area_init_data["overworld_chunk_atlas_id"]
	
	# Load chunk with data
	$OverworldChunk.area_atlas_id = area_enum
	
	# DEBUG: Write global data
	WorldManager.write_world_data(area_enum, WorldManager.AreaHealth, 90)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.passage_complete.connect(_thought_path_complete)
	
	$Player.initalize($OverworldChunk, "writing")

func _thought_path_complete(passage : String):
	if area_enum == 1:
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassage, passage)
		KeyboardInterface.reset()
	if area_enum == 2:
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassage, passage)
		KeyboardInterface.reset()
	WorldManager.current_player_area = WorldManager.STAGE_SELECT
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
