extends Node

# Common Signals
signal scene_change(prev_scene: String, next_scene: String, area_enum: String)

# Stage Select Signals
signal save_game()
signal load_game()

# Session Manager Signals
signal save_session(session_dictionary : Dictionary)

# Player Signals
signal player_moved_tiles(prev_tile_coords : Vector2i, next_tile_coords : Vector2i, keystroke : String)
signal player_writing_keystroke(event : InputEventKey, keystroke: String, sender : CharacterBody2D)
signal player_swap_keystroke(event : InputEventKey, keystroke: String)

# OverworldChunk Signals
signal racing_complete()
signal update_writing_progress()
signal update_racing_progress()

# Keyboard Interface
signal player_keystroke(event : InputEventKey, keystroke: String, total_keystrokes: int)
signal player_racing_keystroke(event : InputEventKey, keystroke: String, sender: CharacterBody2D)

# Typing Interface
signal passage_complete(passage : String)

# Fireball Hazard
signal player_hit()

# HUD 
signal game_over()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
