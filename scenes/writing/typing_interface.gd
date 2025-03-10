extends Control

@onready var text_box = $TypingInterfaceVector/RunningText
@onready var BBCodeCursor = $TypingInterfaceVector/BBCodeCursor

var BBCodeCursorString = "[pulse freq=1.0 color=#ffffff40 ease=-1.0]|[/pulse]"

# TODO: Use this for a cursor 
var current_passage_length = 0

var minimum_passage_size_flag = false

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_render_keystroke)
	text_box.scroll_following = true

	#text_box.text = strip_bbcode(text_box.text)
	#print(text_box.text)
	
func _render_keystroke(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		#text_box.text += keystroke
		#BBCodeCursor.text = " " + BBCodeCursor.text
		#text_box.text = keystroke + text_box.text
		#text_box.text += "[pulse freq=1.0 color=#ffffff40 ease=-1.0]|[/pulse]"
		text_box.text = text_box.text.insert(self.current_passage_length, keystroke)
		current_passage_length += 1
		print(current_passage_length)
		print(text_box.text)
	else: 
		if keystroke == KeyboardInterface.Backspace:
			#text_box.text = text_box.text.left(text_box.text.length() - 1)
			text_box.text = text_box.text.erase(self.current_passage_length - 1)
			current_passage_length -= 1
		if keystroke == KeyboardInterface.Enter and minimum_passage_size_flag == true:
			text_box.text = text_box.text.erase(self.current_passage_length, len(BBCodeCursorString))  # Remove BBCodeCursor
			SignalBus.passage_complete.emit(text_box.text)
	#self.current_passage_length = len(text_box.text)
	
	# TODO: Temporary metric for when the passage is done
	if (total_keystrokes / 5) >= 10:
		$DoneButton.visible = true
		minimum_passage_size_flag = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
