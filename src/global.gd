extends Node

var INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM = {
	# TOP ROW OF KEYBOARD
	Vector2i(17,10) : "q",
	Vector2i(18,10) : "w",
	Vector2i(19,10) : "e",
	Vector2i(20,10) : "r",
	Vector2i(21,10) : "t",
	Vector2i(22,10) : "y",
	Vector2i(23,10) : "u",
	Vector2i(24,10) : "i",
	Vector2i(25,10) : "o",
	Vector2i(26,10) : "p",
	# MIDDLE ROW OF KEYBOARD
	Vector2i(18,11) : "a",
	Vector2i(19,11) : "s",
	Vector2i(20,11) : "d",
	Vector2i(21,11) : "f",
	Vector2i(22,11) : "g",
	Vector2i(23,11) : "h",
	Vector2i(24,11) : "j",
	Vector2i(25,11) : "k",
	Vector2i(26,11) : "l",
	# BOTTOM ROW OF KEYBOARD
	Vector2i(19,12) : "z",
	Vector2i(20,12) : "x",
	Vector2i(21,12) : "c",
	Vector2i(22,12) : "v",
	Vector2i(23,12) : "b",
	Vector2i(24,12) : "n",
	Vector2i(25,12) : "m",
	# PUNCTUATION
	Vector2i(31,9) : "!",
	Vector2i(28,12) : "?",
	Vector2i(27,13) : ".",
}


const TILE_SIZE = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
