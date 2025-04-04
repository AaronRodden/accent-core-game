extends Node

const COMMENT_INFO = "[center]Leave a comment for the next player! (can be left empty if desired!): [/center]"
const INITIALS_INFO = "[center]Enter in your initials to sign! (can be left empty if desired!): [/center]"
const COMMENT_DIVIDER = "----------------------------------------------------------------------------------------------------------------------------------------------"

var gameplay_mode : int
var area_enum : int
var passage : String

var text_box_location = Vector2(112, 96)

var area_comment = [null, null]

var initials = ""
var initials_size = 0

var current_line_count = 0
var new_comment_substring_start = 0
var new_comment_length = 0
# TODO: Implement cursor into comment thread stuff
var BBCodeCursorString = "[pulse freq=1.0 color=#ffffff40 ease=-1.0][color=#000000][code]|[/code][/color][/pulse]"

# Grab the nesseicary data and display it onto the score screen
# NOTE: Writing grabs from function call, Racing grabs from WorldManager data
func load_score_screen(_gameplay_mode: int, _passage : String, _area_enum: int): 
	self.gameplay_mode = _gameplay_mode
	self.area_enum = _area_enum
	var dynamic_area_data = WorldManager.get_dynamic_data(area_enum)
	
	if gameplay_mode == Global.WRITING_MODE:
		self.passage = _passage
		$RacingCanvasLayer.visible = false
		$WritingCanvasLayer.visible = true
		$WritingCanvasLayer/PassageLabel.text = self.passage
		$WritingCanvasLayer/EndingInfo/RichTextLabel.text = COMMENT_INFO

	elif gameplay_mode == Global.RACING_MODE:
		self.passage = dynamic_area_data[WorldManager.CurrAreaPassage]
		$WritingCanvasLayer.visible = false
		$RacingCanvasLayer.visible = true
		
		$RacingCanvasLayer/PassageLabel.visible = true
		$RacingCanvasLayer/PassageLabel.text = self.passage
		
		$RacingCanvasLayer/InitialsBox/RichTextLabel.visible = true
		$RacingCanvasLayer/InitialsBox/RichTextLabel.text += dynamic_area_data[WorldManager.CurrAreaPassageAuthor]
		
		for comment in dynamic_area_data[WorldManager.AreaComments]:
			$RacingCanvasLayer/CommentThreadBox/CommentThread.text += comment[0] + " - " + comment[1] + "\n"
			$RacingCanvasLayer/CommentThreadBox/CommentThread.text += COMMENT_DIVIDER + "\n"
		new_comment_substring_start = $RacingCanvasLayer/CommentThreadBox/CommentThread.text.length()
			
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var keystroke = KeyboardInterface.handle_input_event(event)
		

	
# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_score_screen_input_event)


func _score_screen_input_event(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if $WritingCanvasLayer.visible == true:
		if $WritingCanvasLayer/CommentBox.visible == true:
			_enter_initial_comment(event, keystroke, total_keystrokes)
		else:
			_enter_initials(event, keystroke, total_keystrokes)
	elif $RacingCanvasLayer.visible == true:
		if $RacingCanvasLayer/CommentThreadInitialsBox.visible == false:
			_enter_thread_comment(event, keystroke, total_keystrokes)
		else:
			_enter_thread_initials(event, keystroke, total_keystrokes)

func _enter_initial_comment(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		$WritingCanvasLayer/CommentBox/CommentText.text += keystroke
	else:
		if keystroke == KeyboardInterface.Backspace:
			var curr_comment_length = $WritingCanvasLayer/CommentBox/CommentText.text.length()
			$WritingCanvasLayer/CommentBox/CommentText.text = $WritingCanvasLayer/CommentBox/CommentText.text.erase(curr_comment_length - 1, 1)
		if keystroke == KeyboardInterface.Enter:
			self.area_comment[0] = $WritingCanvasLayer/CommentBox/CommentText.text
			$WritingCanvasLayer/CommentBox.visible = false
			$WritingCanvasLayer/EndingInfo/RichTextLabel.text = INITIALS_INFO

func _enter_initials(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		if initials_size < 3:
			initials += keystroke.capitalize() + " "
			$WritingCanvasLayer/InitialsBox/RichTextLabel.text = initials
			initials_size += 1
	else:
		if keystroke == KeyboardInterface.Backspace:
			initials = ""
			$WritingCanvasLayer/InitialsBox/RichTextLabel.text = ""
			initials_size = 0
		if keystroke == KeyboardInterface.Enter:
			if self.gameplay_mode == Global.WRITING_MODE:
				if initials == "":
					area_comment[1] = "Anonymous"
					self.initials = "Anonymous"
				else:
					area_comment[1] = initials
				_save_writing_data()
			WorldManager.current_player_area = WorldManager.STAGE_SELECT
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
			
			
func _enter_thread_comment(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		$RacingCanvasLayer/CommentThreadBox/CommentThread.text += keystroke
		new_comment_length += 1
	else:
		if keystroke == KeyboardInterface.Backspace:
			var curr_comment_thread_length = $RacingCanvasLayer/CommentThreadBox/CommentThread.text.length()
			$RacingCanvasLayer/CommentThreadBox/CommentThread.text = $RacingCanvasLayer/CommentThreadBox/CommentThread.text.erase(curr_comment_thread_length - 1, 1)
			new_comment_length -= 1
		if keystroke == KeyboardInterface.Enter:
			var new_comment_substring = $RacingCanvasLayer/CommentThreadBox/CommentThread.text.substr(new_comment_substring_start, new_comment_length)
			self.area_comment[0] = new_comment_substring
			$RacingCanvasLayer/CommentThreadInitialsBox.visible = true
			$RacingCanvasLayer/EndingInfo/RichTextLabel.text = INITIALS_INFO
	var line_count = $RacingCanvasLayer/CommentThreadBox/CommentThread.get_line_count()
	$RacingCanvasLayer/CommentThreadBox/CommentThread.scroll_to_line(line_count)
	current_line_count = line_count
	
# TODO: This is copied code from the other initials function!
func _enter_thread_initials(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		if initials_size < 3:
			initials += keystroke.capitalize() + " "
			$RacingCanvasLayer/CommentThreadInitialsBox/RichTextLabel.text = initials
			initials_size += 1
	else:
		if keystroke == KeyboardInterface.Backspace:
			initials = ""
			$RacingCanvasLayer/CommentThreadInitialsBox/RichTextLabel.text = ""
			initials_size = 0
		if keystroke == KeyboardInterface.Enter:
			if initials == "":
				area_comment[1] = "Anonymous"
			else:
				area_comment[1] = initials.strip_edges()
			_save_new_comment()
			SessionManager.reply_count += 1
			WorldManager.current_player_area = WorldManager.STAGE_SELECT
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
func _save_writing_data():
	if area_enum == 1:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.SADNESS_AREA_A, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA_A, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA_A, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 2:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.SADNESS_AREA_B, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA_B, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA_B, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 3:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.SADNESS_AREA_C, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA_C, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA_C, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 4:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.ANGER_AREA_A, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.ANGER_AREA_A, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.ANGER_AREA_A, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 5:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.ANGER_AREA_B, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.ANGER_AREA_B, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.ANGER_AREA_B, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 6:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.ANGER_AREA_C, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.ANGER_AREA_C, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.ANGER_AREA_C, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 7:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.FEAR_AREA_A, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_A, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_A, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 8:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.FEAR_AREA_B, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_B, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_B, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 9:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.FEAR_AREA_C, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_C, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_C, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 10:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.JOY_AREA_A, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.JOY_AREA_A, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.JOY_AREA_A, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 11:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.JOY_AREA_B, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.JOY_AREA_B, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.JOY_AREA_B, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 12:
		if self.area_comment[0] != "":
			WorldManager.write_world_data(WorldManager.JOY_AREA_C, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.FEAR_AREA_C, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.JOY_AREA_C, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	SignalBus.save_game.emit()

func _save_new_comment():
	if self.area_comment[0] != "":
		if area_enum == 1:
			WorldManager.write_world_data(WorldManager.SADNESS_AREA_A, WorldManager.AreaComments, self.area_comment)
		if area_enum == 2:
			WorldManager.write_world_data(WorldManager.SADNESS_AREA_B, WorldManager.AreaComments, self.area_comment)
		if area_enum == 3:
			WorldManager.write_world_data(WorldManager.SADNESS_AREA_C, WorldManager.AreaComments, self.area_comment)
		if area_enum == 4:
			WorldManager.write_world_data(WorldManager.ANGER_AREA_A, WorldManager.AreaComments, self.area_comment)
		if area_enum == 5:
			WorldManager.write_world_data(WorldManager.ANGER_AREA_B, WorldManager.AreaComments, self.area_comment)
		if area_enum == 6:
			WorldManager.write_world_data(WorldManager.ANGER_AREA_C, WorldManager.AreaComments, self.area_comment)
		if area_enum == 7:
			WorldManager.write_world_data(WorldManager.FEAR_AREA_A, WorldManager.AreaComments, self.area_comment)
		if area_enum == 8:
			WorldManager.write_world_data(WorldManager.FEAR_AREA_B, WorldManager.AreaComments, self.area_comment)
		if area_enum == 9:
			WorldManager.write_world_data(WorldManager.FEAR_AREA_C, WorldManager.AreaComments, self.area_comment)
		if area_enum == 10:
			WorldManager.write_world_data(WorldManager.JOY_AREA_A, WorldManager.AreaComments, self.area_comment)
		if area_enum == 11:
			WorldManager.write_world_data(WorldManager.JOY_AREA_B, WorldManager.AreaComments, self.area_comment)
		if area_enum == 12:
			WorldManager.write_world_data(WorldManager.JOY_AREA_C, WorldManager.AreaComments, self.area_comment)
	SignalBus.save_game.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("down"):
		current_line_count += 2
		current_line_count = clamp(current_line_count, 0, $RacingCanvasLayer/CommentThreadBox/CommentThread.get_line_count())
		$RacingCanvasLayer/CommentThreadBox/CommentThread.scroll_to_line(current_line_count)
	if Input.is_action_just_pressed("up"):
		current_line_count -= 2
		current_line_count = clamp(current_line_count, 0, $RacingCanvasLayer/CommentThreadBox/CommentThread.get_line_count())
		$RacingCanvasLayer/CommentThreadBox/CommentThread.scroll_to_line(current_line_count)
