extends Control

@onready var text_box = $TypingInterfaceVector/RunningText
@onready var target_text_box = $TypingInterfaceVector/TargetText
@onready var BBCodeCursor = $TypingInterfaceVector/BBCodeCursor

var BBCodeCursorString = "[pulse freq=1.0 color=#ffffff40 ease=-1.0]|[/pulse]"

var gameplay_mode = 0
var target_passage : String

# TODO: Could use this as a way to see "current word" even when players backspace back into a word
var current_passage_length = 0

var minimum_passage_size_flag = false

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_keystroke_events)
	SignalBus.player_actionable_keystroke.connect(_render_keystroke)
	text_box.scroll_following = true
	
	if target_passage:
		target_text_box.text = target_passage
		target_text_box.visible = true
	
func _keystroke_events(event: InputEventKey, keystroke : String, total_keystrokes : int):
	# TODO: Temporary metric for when the passage is done
	if (total_keystrokes / 5) >= 10 and gameplay_mode == Global.WRITING_MODE:
		$DoneButton.visible = true
		minimum_passage_size_flag = true
	if keystroke == KeyboardInterface.Enter and minimum_passage_size_flag == true:
		text_box.text = text_box.text.erase(self.current_passage_length, len(BBCodeCursorString))  # Remove BBCodeCursor
		SignalBus.passage_complete.emit(text_box.text)

	
func _render_keystroke(event: InputEventKey, keystroke : String):
	if KeyboardInterface.is_input_event_printable(event):
		text_box.text = text_box.text.insert(self.current_passage_length, keystroke)
		current_passage_length += 1
	else: 
		if keystroke == KeyboardInterface.Backspace:
			text_box.text = text_box.text.erase(self.current_passage_length - 1)
			current_passage_length -= 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
