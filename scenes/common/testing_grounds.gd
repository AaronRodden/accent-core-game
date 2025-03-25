extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$OverworldChunk.gameplay_mode = Global.RACING_MODE
	$OverworldChunk.area_atlas_id = WorldManager.JOY_AREA
	$OverworldChunk.thought_path_passage = "Well I want to write a new story about my day. At least I wasen't panicked when the saving didn't work! In many ways I have had a lot of smug joy recently, I mean even being able to play magic makes me content enough! Well I want to write a new story about my day. At least I wasen't panicked"

	$OverworldChunk/Player.initalize($OverworldChunk, "racing")
	$OverworldChunk/ObjectSpawner.initalize($OverworldChunk)
	
	$CanvasLayer/TypingInterface.gameplay_mode = Global.RACING_MODE
	$CanvasLayer/TypingInterface.target_passage = "Well I want to write a new story about my day. At least I wasen't panicked when the saving didn't work! In many ways I have had a lot of smug joy recently, I mean even being able to play magic makes me content enough! Well I want to write a new story about my day. At least I wasen't panicked"
	
	$OverworldChunk.write_existing_passage()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
