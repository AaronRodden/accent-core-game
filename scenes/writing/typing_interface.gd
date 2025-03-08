extends Control

@onready var text_box = $TypingInterfaceVector/RunningText

var minimum_passage_size_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_render_keystroke)
	text_box.scroll_following = true

func _render_keystroke(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		text_box.text += keystroke
	else: 
		if keystroke == KeyboardInterface.Backspace:
			text_box.text = text_box.text.left(text_box.text.length() - 1)
		if keystroke == KeyboardInterface.Enter and minimum_passage_size_flag == true:
			SignalBus.passage_complete.emit(text_box.text)
	
	# TODO: Temporary metric for when the passage is done
	if (total_keystrokes / 5) >= 10:
		$DoneButton.visible = true
		minimum_passage_size_flag = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
