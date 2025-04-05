extends Node

const VERSION_NUMBER = "2.0.0"

# Sceme string constants
const main = "main"
const stage_select = "stage_select"
const thought_path_writing = "thought_path_writing"
const thought_path_racing = "thought_path_racing"
const score_screen = "score_screen"

@onready var WORLD_NODE = get_node("/root/Main/World")

# Variables and Constants
var TILE_SIZE = 64  # in pixels

# Dictionaries and Enums
enum {WRITING_MODE, RACING_MODE}

#var INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM = {
	## Upper case
	#Vector2i(0,0) : "A",
	#Vector2i(1,0) : "B",
	#Vector2i(2,0) : "C",
	#Vector2i(3,0) : "D",
	#Vector2i(4,0) : "E",
	#Vector2i(5,0) : "F",
	#Vector2i(6,0) : "G",
	#Vector2i(7,0) : "H",
	#Vector2i(8,0) : "I",
	#Vector2i(9,0) : "J",
	#Vector2i(10,0) : "K",
	#Vector2i(11,0) : "L",
	#Vector2i(12,0) : "M",
	#Vector2i(13,0) : "N",
	#Vector2i(14,0) : "O",
	#Vector2i(15,0) : "P",
	#Vector2i(16,0) : "Q",
	#Vector2i(17,0) : "R",
	#Vector2i(18,0) : "S",
	#Vector2i(19,0) : "T",
	#Vector2i(20,0) : "U",
	#Vector2i(21,0) : "V",
	#Vector2i(22,0) : "W",
	#Vector2i(23,0) : "X",
	#Vector2i(24,0) : "Y",
	#Vector2i(25,0) : "Z",
	## lower case
	#Vector2i(0,1) : "a",
	#Vector2i(1,1) : "b",
	#Vector2i(2,1) : "c",
	#Vector2i(3,1) : "d",
	#Vector2i(4,1) : "e",
	#Vector2i(5,1) : "f",
	#Vector2i(6,1) : "g",
	#Vector2i(7,1) : "h",
	#Vector2i(8,1) : "i",
	#Vector2i(9,1) : "j",
	#Vector2i(10,1) : "k",
	#Vector2i(11,1) : "l",
	#Vector2i(12,1) : "m",
	#Vector2i(13,1) : "n",
	#Vector2i(14,1) : "o",
	#Vector2i(15,1) : "p",
	#Vector2i(16,1) : "q",
	#Vector2i(17,1) : "r",
	#Vector2i(18,1) : "s",
	#Vector2i(19,1) : "t",
	#Vector2i(20,1) : "u",
	#Vector2i(21,1) : "v",
	#Vector2i(22,1) : "w",
	#Vector2i(23,1) : "x",
	#Vector2i(24,1) : "y",
	#Vector2i(25,1) : "z",
#}

var INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM = {
	# Upper case
	"A" : Vector2i(0,0),
	"B" : Vector2i(1,0),
	"C" : Vector2i(2,0),
	"D" : Vector2i(3,0),
	"E" : Vector2i(4,0),
	"F" : Vector2i(5,0),
	"G" : Vector2i(6,0),
	"H" : Vector2i(7,0),
	"I" : Vector2i(8,0), 
	"J" : Vector2i(9,0),  
	"K" : Vector2i(10,0),  
	"L" : Vector2i(11,0),  
	"M" : Vector2i(12,0),  
	"N" : Vector2i(13,0),  
	"O" : Vector2i(14,0),  
	"P" : Vector2i(15,0),  
	"Q" : Vector2i(16,0),  
	"R" : Vector2i(17,0),  
	"S" : Vector2i(18,0),  
	"T" : Vector2i(19,0),  
	"U" : Vector2i(20,0), 
	"V" : Vector2i(21,0), 
	"W" : Vector2i(22,0),  
	"X" : Vector2i(23,0),  
	"Y" : Vector2i(24,0),  
	"Z" : Vector2i(25,0),  
	# lower case
	"a" : Vector2i(0,1),  
	"b" : Vector2i(1,1),  
	"c" : Vector2i(2,1),  
	"d" : Vector2i(3,1),  
	"e" : Vector2i(4,1),  
	"f" : Vector2i(5,1),  
	"g" : Vector2i(6,1),  
	"h" : Vector2i(7,1),  
	"i" : Vector2i(8,1),  
	"j" : Vector2i(9,1),  
	"k" : Vector2i(10,1),  
	"l" : Vector2i(11,1),  
	"m" : Vector2i(12,1),  
	"n" : Vector2i(13,1),  
	"o" : Vector2i(14,1),  
	"p" : Vector2i(15,1),  
	"q" : Vector2i(16,1), 
	"r" : Vector2i(17,1),  
	"s" : Vector2i(18,1),  
	"t" : Vector2i(19,1),  
	"u" : Vector2i(20,1),  
	"v" : Vector2i(21,1),  
	"w" : Vector2i(22,1),  
	"x" : Vector2i(23,1),  
	"y" : Vector2i(24,1),  
	"z" : Vector2i(25,1),
	# Numbers
	"1" : Vector2i(0,2),
	"2" : Vector2i(1,2),
	"3" : Vector2i(2,2),
	"4" : Vector2i(3,2),
	"5" : Vector2i(4,2),
	"6" : Vector2i(5,2),
	"7" : Vector2i(6,2),
	"8" : Vector2i(7,2),
	"9" : Vector2i(8,2),
	"0" : Vector2i(9,2),
	# Punctuation
	"." : Vector2i(10,2),
	"," : Vector2i(11,2),
	"!" : Vector2i(12,2),
	"?" : Vector2i(13,2),
	# Special Characters
	"(" : Vector2i(14,2),
	")" : Vector2i(15,2),
	"[" : Vector2i(16,2),
	"]" : Vector2i(17,2),
	"{" : Vector2i(18,2),
	"}" : Vector2i(19,2),
	":" : Vector2i(20,2),
	";" : Vector2i(21,2),
	"\'" : Vector2i(22,2), # TODO: We are missing single quotes in the tilesets right now!
	"@" : Vector2i(23,2),
	"#" : Vector2i(24,2),
	"&" : Vector2i(25,2),
	# Spacing
	" " : Vector2i(0,6),
}

var INTRUSIVE_WORD_BANK = ['happy', 'sad', 'angry', 'excited', 'nervous', 'frustrated', 'joyful', 'anxious', 'peaceful', 'annoyed', 'hopeful', 'disappointed', 'grateful', 'fearful', 'content', 'guilty', 'embarrassed', 'proud', 'lonely', 'overwhelmed', 'relaxed', 'confused', 'jealous', 'loving', 'ashamed', 'determined', 'bored', 'resentful', 'ecstatic', 'miserable', 'furious', 'eager', 'doubtful', 'inspired', 'nostalgic', 'sorrowful', 'optimistic', 'hesitant', 'panicked', 'envious', 'relieved', 'indifferent', 'melancholic', 'startled', 'affectionate', 'irritated', 'empowered', 'insecure', 'heartbroken', 'smug', 'remorseful', 'suspicious', 'adventurous', 'weary', 'mortified', 'triumphant', 'defensive', 'sentimental', 'restless', 'vulnerable', 'discouraged', 'confident', 'betrayed', 'elated', 'furious', 'amused', 'sorrowful', 'exhausted', 'bitter', 'hopeful', 'shy', 'tender', 'uneasy', 'curious', 'regretful', 'cheerful', 'weary', 'brave', 'guilty', 'panicked', 'humiliated', 'liberated', 'comforted', 'enraptured', 'aggravated', 'uneasy', 'ambitious', 'stunned', 'devastated', 'enthusiastic', 'inadequate', 'loving']



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
