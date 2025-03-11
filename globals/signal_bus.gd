extends Node

# Stage Select Signals
signal save_game()
signal load_game()

# Player Signals
signal player_moved_tiles(prev_tile_coords : Vector2i, next_tile_coords : Vector2i, keystroke : String)
signal player_actionable_keystroke(event : InputEventKey, keystroke: String)
signal player_swap_keystroke(event : InputEventKey, keystroke: String)

# Keyboard Interface
signal player_keystroke(event : InputEventKey, keystroke: String, total_keystrokes: int)
signal player_racing_keystroke(event : InputEventKey, keystroke: String)

# Typing Interface
signal passage_complete(passage : String)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
