extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_render_keystroke)

# TODO: This is a test right now!
func _render_keystroke(keystroke_event: InputEventKey):
	if keystroke_event.pressed:
		var physical_key = translate_physical_key(keystroke_event)
		if physical_key == "backspace":
			$TypingInterfaceVector/Label.text = $TypingInterfaceVector/Label.text.left($TypingInterfaceVector/Label.text.length() - 1)
		else:
			$TypingInterfaceVector/Label.text += physical_key

func translate_physical_key(input_event : InputEventKey):
	var keystroke = OS.get_keycode_string(input_event.get_keycode_with_modifiers()).to_lower()
	# TODO: NumLock will change the behavior of the keypad keys
	
	# Keypad 
	if keystroke == "insert":
		keystroke = "0"
	elif keystroke == "end":
		keystroke = "1"
	elif keystroke == "down":
		keystroke = "2"
	elif keystroke == "pagedown":
		keystroke = "3"
	elif keystroke == "left":
		keystroke = "4"
	elif keystroke == "clear":
		keystroke = "5"
	elif keystroke == "right":
		keystroke = "6"
	elif keystroke == "home":
		keystroke = "7"
	elif keystroke == "up":
		keystroke = "8"
	elif keystroke == "pageup":
		keystroke = "9"
	# Spacing
	if keystroke == "space":
		keystroke = " "
	# Punctuation
	if keystroke == "shift+slash":
		keystroke = "?"
	elif keystroke == "shift+1":
		keystroke = "!"
	elif keystroke == "period":
		keystroke = "."
	# Special Keys
	if keystroke == "capslock":
		keystroke = "capslock"
	# Shift keys
	if keystroke == "shift":
		keystroke = ""
	if keystroke.contains("shift") and keystroke.contains("+"):
		keystroke = str(keystroke[-1]).to_upper()
	return keystroke

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
