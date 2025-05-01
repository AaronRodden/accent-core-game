extends Node

const COMMENT_INFO = "[center]Leave a comment for the next player! (can be left empty if desired!): [/center]"
const INITIALS_INFO = "[center]Enter in your initials to sign! (can be left empty if desired!): [/center]"
const COMMENT_DIVIDER = "----------------------------------------------------------------------------------------------------------------------------------------------"
var COMMENT_TOOL_TIP = "[color=4d4d4d] Type a key to leave a comment! [/color]"

var gameplay_mode : int
var area_enum : int
var passage : String

var text_box_location = Vector2(112, 96)

var area_comment = [null, null]

# Writing sprites
var story_overview_sprite : Node
var story_title_sprite : Node
var story_title : String

# Racing sprites
var story_review_sprite : Node
var story_comments_sprite : Node
var commenting_sprite : Node

var initials = ""
var initials_size = 0

var current_line_count = 0
var new_comment_length = 0
# TODO: Implement cursor into comment thread stuff
var BBCodeCursorString = "[pulse freq=1.0 color=#ffffff40 ease=-1.0][color=#000000][code]|[/code][/color][/pulse]"

# Grab the nesseicary data and display it onto the score screen
# NOTE: Writing grabs from function call, Racing grabs from WorldManager data
func load_score_screen(_gameplay_mode: int, _passage : String, _area_enum: int, _author = ""): 
	self.gameplay_mode = _gameplay_mode
	self.area_enum = _area_enum
	var init_area_data = WorldManager.get_initalization_data(area_enum)
	var dynamic_area_data = WorldManager.get_dynamic_data(area_enum)
	
	if gameplay_mode == Global.WRITING_MODE:
		self.passage = _passage
		$RacingCanvasLayer.visible = false
		$WritingCanvasLayer.visible = true
		self.initials = _author
		
		match area_enum:
			WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
				story_overview_sprite = $WritingCanvasLayer/StoryOverviewSadness
				story_title_sprite = $WritingCanvasLayer/StoryTitleSadness
			WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
				story_overview_sprite = $WritingCanvasLayer/StoryOverviewAnger
				story_title_sprite = $WritingCanvasLayer/StoryTitleAnger
			WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
				story_overview_sprite = $WritingCanvasLayer/StoryOverviewFear
				story_title_sprite = $WritingCanvasLayer/StoryTitleFear
			WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
				story_overview_sprite = $WritingCanvasLayer/StoryOverviewJoy
				story_title_sprite = $WritingCanvasLayer/StoryTitleJoy
		
		# Populate story overview
		story_overview_sprite.get_child(0).text = init_area_data[WorldManager.Prompt]
		story_overview_sprite.get_child(1).text = passage
		story_overview_sprite.visible = true

	elif gameplay_mode == Global.RACING_MODE:
		self.passage = dynamic_area_data[WorldManager.CurrAreaPassage]
		self.area_comment[1] = _author
		$WritingCanvasLayer.visible = false
		$RacingCanvasLayer.visible = true
		
		match area_enum:
			WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
				story_review_sprite = $RacingCanvasLayer/ReviewStorySadness
				story_comments_sprite = $RacingCanvasLayer/ReviewCommentsSadness
				commenting_sprite = $RacingCanvasLayer/CommentingSadness
			WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
				story_review_sprite = $RacingCanvasLayer/ReviewStoryAnger
				story_comments_sprite = $RacingCanvasLayer/ReviewCommentsAnger
				commenting_sprite = $RacingCanvasLayer/CommentingAnger
			WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
				story_review_sprite = $RacingCanvasLayer/ReviewStoryFear
				story_comments_sprite = $RacingCanvasLayer/ReviewCommentsFear
				commenting_sprite = $RacingCanvasLayer/CommentingFear
			WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
				story_review_sprite = $RacingCanvasLayer/ReviewStoryJoy
				story_comments_sprite = $RacingCanvasLayer/ReviewCommentsJoy
				commenting_sprite = $RacingCanvasLayer/CommentingJoy
		
		# Fill in information
		story_review_sprite.get_child(0).text = dynamic_area_data[WorldManager.CurrAreaPassageTitle]
		story_review_sprite.get_child(1).text = dynamic_area_data[WorldManager.CurrAreaPassageAuthor]
		story_review_sprite.get_child(2).text = dynamic_area_data[WorldManager.CurrAreaPassage]
		
		for comment in dynamic_area_data[WorldManager.AreaComments]:
			#$RacingCanvasLayer/CommentThreadBox/CommentThread.text += comment[0] + " - " + comment[1] + "\n"
			#$RacingCanvasLayer/CommentThreadBox/CommentThread.text += COMMENT_DIVIDER + "\n"
			story_comments_sprite.get_child(0).text += comment[0] + " - " + comment[1] + "\n"
			story_comments_sprite.get_child(0).text += COMMENT_DIVIDER + "\n"
		story_comments_sprite.get_child(0).text += COMMENT_TOOL_TIP
		
		story_review_sprite.visible = true
			
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var keystroke = KeyboardInterface.handle_input_event(event)
		

	
# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_score_screen_input_event)


func _score_screen_input_event(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if $WritingCanvasLayer.visible == true:
		if story_overview_sprite.visible == true:
			_review_story(event, keystroke, total_keystrokes)
		else:
			_enter_title(event, keystroke, total_keystrokes)
	elif $RacingCanvasLayer.visible == true:
		if story_review_sprite.visible == true:
			_review_story(event, keystroke, total_keystrokes)
		else:
			_enter_thread_comment(event, keystroke, total_keystrokes)

func _review_story(event: InputEventKey, keystroke : String, total_keystrokes : int):
	
	if $WritingCanvasLayer.visible == true:
		if keystroke == KeyboardInterface.Enter:
			story_overview_sprite.visible = false
			story_title_sprite.visible = true
	elif $RacingCanvasLayer.visible == true:
		if keystroke == KeyboardInterface.Enter:
			story_review_sprite.visible = false
			story_comments_sprite.visible = true
		
func _enter_title(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		story_title_sprite.get_child(0).text += keystroke
	else:
		if keystroke == KeyboardInterface.Backspace:
			var curr_comment_length = story_title_sprite.get_child(0).text.length()
			story_title_sprite.get_child(0).text = story_title_sprite.get_child(0).text.erase(curr_comment_length - 1, 1)
		if keystroke == KeyboardInterface.Enter:
				self.story_title = story_title_sprite.get_child(0).text
				if initials == "":
					self.initials = "Anonymous"
				_save_writing_data()
				WorldManager.current_player_area = WorldManager.STAGE_SELECT
				SceneTransition.change_scene("res://scenes/main/main.tscn", "change_scene")
			
			
func _enter_thread_comment(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if story_comments_sprite.get_child(0).text.contains(COMMENT_TOOL_TIP):
		story_comments_sprite.get_child(0).text = story_comments_sprite.get_child(0).text.replace(COMMENT_TOOL_TIP, "")
	if KeyboardInterface.is_input_event_printable(event):
		story_comments_sprite.get_child(0).text += keystroke
		new_comment_length += 1
	else:
		if keystroke == KeyboardInterface.Backspace:
			var curr_comment_thread_length = story_comments_sprite.get_child(0).text.length()
			story_comments_sprite.get_child(0).text = story_comments_sprite.get_child(0).text.erase(curr_comment_thread_length - 1, 1)
			new_comment_length -= 1
		if keystroke == KeyboardInterface.Enter:
			var last_line_break_index = story_comments_sprite.get_child(0).text.rfind(COMMENT_DIVIDER)
			var new_comment_substring = story_comments_sprite.get_child(0).text.substr(last_line_break_index+COMMENT_DIVIDER.length()+1, -1)
			if new_comment_substring == "":
				self.area_comment[0] = "Thanks for the writing"
			else:
				self.area_comment[0] = new_comment_substring
			_save_new_comment()
			SessionManager.reply_count += 1
			WorldManager.current_player_area = WorldManager.STAGE_SELECT
			SceneTransition.change_scene("res://scenes/main/main.tscn", "change_scene")
	var line_count = story_comments_sprite.get_child(0).get_line_count()
	story_comments_sprite.get_child(0).scroll_to_line(line_count)
	current_line_count = line_count
	
	
func _save_writing_data():
	WorldManager.write_world_data(area_enum, WorldManager.CurrAreaPassage, self.passage.strip_edges())
	WorldManager.write_world_data(area_enum, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
	WorldManager.write_world_data(area_enum, WorldManager.CurrAreaPassageTitle, self.story_title.strip_edges())
	KeyboardInterface.reset()
	SignalBus.save_game.emit()

func _save_new_comment():
	WorldManager.write_world_data(area_enum, WorldManager.AreaComments, self.area_comment)
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
