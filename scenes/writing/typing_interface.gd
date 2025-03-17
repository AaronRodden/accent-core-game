extends Control

@onready var text_box = $TypingInterfaceVector/RunningText

@export var gray = Color.GRAY
@export var black = Color.BLACK
@export var blue = Color("#2F5BAC")
@export var light_blue = Color("#80A8F2")

@export var interface_partner : Control
@export var player : CharacterBody2D

var BBCodeCursorString = "[pulse freq=1.0 color=#ffffff40 ease=-1.0][color=#000000][code]|[/code][/color][/pulse]"
var current_char_index : int
var next_char_index : int

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
	SignalBus.player_writing_keystroke.connect(_render_writing_keystroke)
	SignalBus.player_racing_keystroke.connect(_render_racing_keystroke)
	text_box.scroll_following = true
	
	if gameplay_mode == Global.WRITING_MODE:
		text_box.text += BBCodeCursorString
	
	if gameplay_mode == Global.RACING_MODE:
		if target_passage:
			text_box.text = target_passage
			
	current_char_index = 0
	next_char_index = 1

func scroll_to_char_position():
	text_box.scroll_to_line(text_box.get_character_line(current_char_index))
	
func _keystroke_events(event: InputEventKey, keystroke : String, total_keystrokes : int):
	# TODO: Temporary metric for when the passage is done
	# TODO: Right now this logic is locked into TypingInterface, perhaps a mistake
	if (total_keystrokes / 5) >= 60 and gameplay_mode == Global.WRITING_MODE:
		$DoneButton.visible = true
		minimum_passage_size_flag = true
	if keystroke == KeyboardInterface.Enter and minimum_passage_size_flag == true:
		text_box.text = text_box.text.erase(self.current_char_index, len(BBCodeCursorString))  # Remove BBCodeCursor
		SignalBus.passage_complete.emit(text_box.text)
		

func _render_writing_keystroke(event: InputEventKey, keystroke : String, sender : CharacterBody2D):
	if sender == player:
		if KeyboardInterface.is_input_event_printable(event):
			text_box.text = text_box.text.insert(self.current_char_index, keystroke)
			current_char_index += 1
		else: 
			if keystroke == KeyboardInterface.Backspace:
				text_box.text = text_box.text.erase(self.current_char_index - 1)
				current_char_index -= 1
	
func lock():
	self.visible = false
	interface_partner.visible = true

# TODO: In racing mode sometimes typing at the end of the text box gets akward! 
func _render_racing_keystroke(event: InputEventKey, keystroke: String, sender: CharacterBody2D):
	if sender == player:
		if KeyboardInterface.is_input_event_printable(event):
			var finished_text = get_bbcode_color_tag(blue) + text_box.text.substr(0, next_char_index) + get_bbcode_end_color_tag()
			var unfinished_text = ""
			
			if next_char_index != target_passage.length():
				unfinished_text = get_bbcode_color_tag(light_blue) + text_box.text.substr(next_char_index, target_passage.length() - next_char_index + 1) + get_bbcode_end_color_tag()
			
			text_box.parse_bbcode(finished_text + BBCodeCursorString + unfinished_text)
			current_char_index += 1
			next_char_index += 1
		else: 
			if keystroke == KeyboardInterface.Backspace:
				var finished_text = get_bbcode_color_tag(blue) + text_box.text.substr(0,  current_char_index - 1) + get_bbcode_end_color_tag()
				var unfinished_text = ""
				
				unfinished_text = get_bbcode_color_tag(light_blue) + text_box.text.substr(current_char_index-1, target_passage.length() - current_char_index + 1) + get_bbcode_end_color_tag()
				
				text_box.parse_bbcode(finished_text + BBCodeCursorString + unfinished_text)
				current_char_index -= 1
				next_char_index -= 1

func get_bbcode_color_tag(color : Color):
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag():
	return "[/color]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	scroll_to_char_position()
