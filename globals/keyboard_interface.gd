extends Node

# Keystroke constants
const Backspace = "Backspace"
const Shift = "Shift"
const Enter = "Enter"
const Tab = "Tab"
const Space = " "

# TODO: Maybe this should be an object that lives and dies alongside typing interfaces?
# With this pattern then data will be persistant with individual sessions!
var total_keystrokes = 0
var wpm = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_input_event_printable(event : InputEventKey):
	if !(event.keycode & KEY_SPECIAL): 
		return true
	else:
		return false

func handle_input_event(event : InputEventKey):
	var keystroke : String
	if !(event.keycode & KEY_SPECIAL): 
		keystroke = String.chr(event.unicode)
		total_keystrokes += 1
	elif event.keycode & KEY_SPECIAL:
		keystroke = OS.get_keycode_string(event.keycode)
	_calculate_current_wpm()
	SignalBus.player_keystroke.emit(event, keystroke, total_keystrokes)
	return keystroke
	
func reset():
	total_keystrokes = 0
	wpm = 0

func _calculate_current_wpm():
	pass
	#var wpm = (total_keystrokes / 5) * 
