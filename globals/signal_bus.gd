extends Node

# Player Signals
signal player_moved_tiles(prev_tile_coords : Vector2i, next_tile_coords : Vector2i, keystroke : String)

# Keyboard Interface
signal player_keystroke(event : InputEventKey, keystroke: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
