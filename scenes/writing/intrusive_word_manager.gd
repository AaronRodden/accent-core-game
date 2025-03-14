extends Control

# Constants magic numbers from screen sizing (e.g. 1920x1080 screen) and typing interface size (~300 px)
const SPAWN_AREA_X_MIN = 64
const SPAWN_AREA_X_MAX = 1920 - 64
const SPAWN_AREA_Y_MIN = 64
const SPAWN_AREA_Y_MAX = (1080 - 300) - 64

@onready var timer = $Timer

var IntrusiveWord = preload("res://scenes/writing/intrusive_word.tscn")

var rng = RandomNumberGenerator.new()

var intrusive_word_count = 0
var active_words = []
var running_string = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_check_active_words)

	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: This is a big buggy / not desired behavior for when someone presses space during a word and wants to go back.
func _check_active_words(event : InputEventKey, keystroke: String, total_keystrokes: int):
	if keystroke == KeyboardInterface.Space:
		self.running_string = ""
	elif keystroke == KeyboardInterface.Backspace:
		self.running_string = self.running_string.substr(0, len(running_string)-1)
	elif KeyboardInterface.is_input_event_printable(event):
		self.running_string += keystroke
	var running_length = len(running_string)
	for word in self.active_words:
		word.running_string = running_string
		word.check_word()
			

func _on_timer_timeout():
	if self.intrusive_word_count < 3:
		pass
		var intrusive_word = IntrusiveWord.instantiate()
		intrusive_word.target_word = Global.INTRUSIVE_WORD_BANK.pick_random()
		intrusive_word.position = Vector2(rng.randi_range(SPAWN_AREA_X_MIN,SPAWN_AREA_X_MAX), rng.randi_range(SPAWN_AREA_Y_MIN,SPAWN_AREA_Y_MAX))
		add_child(intrusive_word)
		self.intrusive_word_count += 1

# TODO : How can I make this more specific to IntrusiveWords rather then Sprite2D?
func _on_child_entered_tree(node):
	if node.get_class() == "Sprite2D":
		self.active_words.append(node)


func _on_child_exiting_tree(node):
	if node.get_class() == "Sprite2D":
		self.active_words.erase(node)
		self.running_string = ""
		intrusive_word_count -= 1
