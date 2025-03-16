extends Node

var area_enum : int

var score_scene = preload("res://menus/score_screen.tscn").instantiate()


func load_level(area_init_data : Dictionary, area_dynamic_data : Dictionary):
	# Initalize variables
	area_enum = area_init_data[WorldManager.AtlasID]
	
	# Load chunk with data
	$OverworldChunk.gameplay_mode = Global.WRITING_MODE
	$OverworldChunk.area_atlas_id = area_enum
	
	$CanvasLayer/TypingInterface.gameplay_mode = Global.WRITING_MODE
	
	# DEBUG: Write global data
	WorldManager.write_world_data(area_enum, WorldManager.AreaHealth, 90)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.passage_complete.connect(_thought_path_complete)
	
	$Player.initalize($OverworldChunk, "writing")

func _thought_path_complete(passage : String):
	# Change to score scene
	score_scene.load_score_screen(area_enum, passage)
	Global.WORLD_NODE.add_child(score_scene)
	get_node("/root/Main/World/ThoughtPathWriting").queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
