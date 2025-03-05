extends Node

# Keystroke constants
const Backspace = "Backspace"
const Shift = "Shift"

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
	elif event.keycode & KEY_SPECIAL:
		keystroke = OS.get_keycode_string(event.keycode)
	SignalBus.player_keystroke.emit(event, keystroke)
	return keystroke
