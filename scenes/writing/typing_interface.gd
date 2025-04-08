extends Control

@export var interface_partner : Control
@export var player : CharacterBody2D

var BBCodeCursorString = "[pulse freq=1.0 color=#ffffff40 ease=-1.0][color=#000000][code]|[/code][/color][/pulse]"
var current_char_index : int
var next_char_index : int


var info_box : Sprite2D
var info_text : RichTextLabel
var typing_interface : Sprite2D
var typing_text : RichTextLabel

var untyped_color : Color
var typed_color : Color

var gameplay_mode = 0
var area_enum : int
var prompt : String
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
	
	match area_enum:
		WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
			$SadnessInterface.visible = true
			info_box = $SadnessInterface/InfoBoxSadness
			info_text = $SadnessInterface/InfoText
			typing_interface = $SadnessInterface/TypingInterfaceSadness
			typing_text = $SadnessInterface/RunningText
			untyped_color = Color("#80A8F2")  # light blue
			typed_color = Color("#2F5BAC") # blue
		WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
			$AngerInterface.visible = true
			info_box = $AngerInterface/InfoBoxAnger
			info_text = $AngerInterface/InfoText
			typing_interface = $AngerInterface/TypingInterfaceAnger
			typing_text = $AngerInterface/RunningText
			untyped_color = Color("#D68191") # light red
			typed_color = Color("#AC2F46") # red
		WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
			$FearInterface.visible = true
			info_box = $FearInterface/InfoBoxFear
			info_text = $FearInterface/InfoText
			typing_interface = $FearInterface/TypingInterfaceFear
			typing_text = $FearInterface/RunningText
			untyped_color = Color("#9D9D9D")  # grey
			typed_color = Color("#FFFFFF")  # white
		WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
			$JoyInterface.visible = true
			info_box = $JoyInterface/InfoBoxJoy
			info_text = $JoyInterface/InfoText
			typing_interface = $JoyInterface/TyingInterfaceJoy
			typing_text = $JoyInterface/RunningText
			untyped_color = Color("#CDBF71")  # light gold
			typed_color = Color("#A18F27")  # gold
	
	if gameplay_mode == Global.WRITING_MODE:
		info_text.text = prompt
		typing_text.text += BBCodeCursorString
	
	if gameplay_mode == Global.RACING_MODE:
		if target_passage:
			typing_text.set("theme_override_colors/default_color", untyped_color)
			typing_text.text = BBCodeCursorString
			typing_text.text += target_passage
	
	typing_text.scroll_following = true

	
	current_char_index = 0
	next_char_index = 1

func scroll_to_char_position():
	typing_text.scroll_to_line(typing_text.get_character_line(current_char_index))
	
func _keystroke_events(event: InputEventKey, keystroke : String, total_keystrokes : int):
	# TODO: Right now this logic is locked into TypingInterface, perhaps a mistake
	if keystroke == KeyboardInterface.Enter and minimum_passage_size_flag == true:
		typing_text.text = typing_text.text.erase(self.current_char_index, len(BBCodeCursorString))  # Remove BBCodeCursor
		SignalBus.passage_complete.emit(typing_text.text)
		

func _render_writing_keystroke(event: InputEventKey, keystroke : String, sender : CharacterBody2D):
	if sender == player:
		if KeyboardInterface.is_input_event_printable(event):
			typing_text.text = typing_text.text.insert(self.current_char_index, keystroke)
			current_char_index += 1
		else: 
			if keystroke == KeyboardInterface.Backspace:
				typing_text.text = typing_text.text.erase(self.current_char_index - 1)
				current_char_index -= 1
	
func lock():
	self.visible = false
	interface_partner.visible = true

func _render_racing_keystroke(event: InputEventKey, keystroke: String, sender: CharacterBody2D):
	if sender == player:
		if current_char_index == 0:
			typing_text.text = typing_text.text.lstrip(BBCodeCursorString)
		
		if KeyboardInterface.is_input_event_printable(event):
			var finished_text = get_bbcode_color_tag(typed_color) + typing_text.text.substr(0, next_char_index) + get_bbcode_end_color_tag()
			var unfinished_text = ""
			
			if next_char_index != target_passage.length():
				unfinished_text = get_bbcode_color_tag(untyped_color) + typing_text.text.substr(next_char_index, target_passage.length() - next_char_index + 1) + get_bbcode_end_color_tag()
			
			typing_text.parse_bbcode(finished_text + BBCodeCursorString + unfinished_text)
			current_char_index += 1
			next_char_index += 1
		else: 
			if keystroke == KeyboardInterface.Backspace:
				var finished_text = get_bbcode_color_tag(typed_color) + typing_text.text.substr(0,  current_char_index - 1) + get_bbcode_end_color_tag()
				var unfinished_text = ""
				
				unfinished_text = get_bbcode_color_tag(untyped_color) + typing_text.text.substr(current_char_index-1, target_passage.length() - current_char_index + 1) + get_bbcode_end_color_tag()
				
				typing_text.parse_bbcode(finished_text + BBCodeCursorString + unfinished_text)
				current_char_index -= 1
				next_char_index -= 1

func get_bbcode_color_tag(color : Color):
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag():
	return "[/color]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	scroll_to_char_position()
