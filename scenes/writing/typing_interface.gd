extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_render_keystroke)

func _render_keystroke(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		$TypingInterfaceVector/RunningText.text += keystroke
	else: 
		if keystroke == "Backspace":
			$TypingInterfaceVector/RunningText.text = $TypingInterfaceVector/RunningText.text.left($TypingInterfaceVector/RunningText.text.length() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
