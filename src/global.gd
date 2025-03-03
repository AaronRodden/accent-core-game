extends Node

#var INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM = {
	## TOP ROW OF KEYBOARD
	#Vector2i(17,10) : "q",
	#Vector2i(18,10) : "w",
	#Vector2i(19,10) : "e",
	#Vector2i(20,10) : "r",
	#Vector2i(21,10) : "t",
	#Vector2i(22,10) : "y",
	#Vector2i(23,10) : "u",
	#Vector2i(24,10) : "i",
	#Vector2i(25,10) : "o",
	#Vector2i(26,10) : "p",
	## MIDDLE ROW OF KEYBOARD
	#Vector2i(18,11) : "a",
	#Vector2i(19,11) : "s",
	#Vector2i(20,11) : "d",
	#Vector2i(21,11) : "f",
	#Vector2i(22,11) : "g",
	#Vector2i(23,11) : "h",
	#Vector2i(24,11) : "j",
	#Vector2i(25,11) : "k",
	#Vector2i(26,11) : "l",
	## BOTTOM ROW OF KEYBOARD
	#Vector2i(19,12) : "z",
	#Vector2i(20,12) : "x",
	#Vector2i(21,12) : "c",
	#Vector2i(22,12) : "v",
	#Vector2i(23,12) : "b",
	#Vector2i(24,12) : "n",
	#Vector2i(25,12) : "m",
	## PUNCTUATION
	#Vector2i(31,9) : "!",
	#Vector2i(28,12) : "?",
	#Vector2i(27,13) : ".",
#}

var INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM = {
	# Upper case
	Vector2i(0,0) : "A",
	Vector2i(1,0) : "B",
	Vector2i(2,0) : "C",
	Vector2i(3,0) : "D",
	Vector2i(4,0) : "E",
	Vector2i(5,0) : "F",
	Vector2i(6,0) : "G",
	Vector2i(7,0) : "H",
	Vector2i(8,0) : "I",
	Vector2i(9,0) : "J",
	Vector2i(10,0) : "K",
	Vector2i(11,0) : "L",
	Vector2i(12,0) : "M",
	Vector2i(13,0) : "N",
	Vector2i(14,0) : "O",
	Vector2i(15,0) : "P",
	Vector2i(16,0) : "Q",
	Vector2i(17,0) : "R",
	Vector2i(18,0) : "S",
	Vector2i(19,0) : "T",
	Vector2i(20,0) : "U",
	Vector2i(21,0) : "V",
	Vector2i(22,0) : "W",
	Vector2i(23,0) : "X",
	Vector2i(24,0) : "Y",
	Vector2i(25,0) : "Z",
	# lower case
	Vector2i(0,1) : "a",
	Vector2i(1,1) : "b",
	Vector2i(2,1) : "c",
	Vector2i(3,1) : "d",
	Vector2i(4,1) : "e",
	Vector2i(5,1) : "f",
	Vector2i(6,1) : "g",
	Vector2i(7,1) : "h",
	Vector2i(8,1) : "i",
	Vector2i(9,1) : "j",
	Vector2i(10,1) : "k",
	Vector2i(11,1) : "l",
	Vector2i(12,1) : "m",
	Vector2i(13,1) : "n",
	Vector2i(14,1) : "o",
	Vector2i(15,1) : "p",
	Vector2i(16,1) : "q",
	Vector2i(17,1) : "r",
	Vector2i(18,1) : "s",
	Vector2i(19,1) : "t",
	Vector2i(20,1) : "u",
	Vector2i(21,1) : "v",
	Vector2i(22,1) : "w",
	Vector2i(23,1) : "x",
	Vector2i(24,1) : "y",
	Vector2i(25,1) : "z",
}

# Constants
const TILE_SIZE = 64

# Global data
var world_resources_global_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
