extends Node

const COMMENT_INFO = "[center]Leave a comment for the next player! (can be left empty if desired!): [/center]"
const INITIALS_INFO = "[center]Enter in your initials to sign! (can be left empty if desired!): [/center]"

var gameplay_mode : int
var area_enum : int
var passage : String

var text_box_location = Vector2(112, 96)

var area_comment = [null, null]

var initials = ""
var initials_size = 0

# Grab the nesseicary data and display it onto the score screen
# NOTE: Writing grabs from function call, Racing grabs from WorldManager data
func load_score_screen(gameplay_mode: int, passage : String, area_enum: int): 
	self.gameplay_mode = gameplay_mode
	self.area_enum = area_enum
	var dynamic_area_data = WorldManager.get_dynamic_data(area_enum)
	
	if gameplay_mode == Global.WRITING_MODE:
		self.passage = passage
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
		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var keystroke = KeyboardInterface.handle_input_event(event)
		
		#if keystroke == KeyboardInterface.Tab:
			#_swap_passage_interfaces()

#func _swap_passage_interfaces():
	## Swap Story Overview sprite order
	#var secondary_story_node_index = $RacingCanvasLayer/StoryOverviewB.get_index()
	#if secondary_story_node_index == 0:S
		#$RacingCanvasLayer.move_child($RacingCanvasLayer/StoryOverviewB, 1)
	#else: 
		#$RacingCanvasLayer.move_child($RacingCanvasLayer/StoryOverviewA, 1)
	#
	## Visiblity swaps
	#$RacingCanvasLayer/PassageLabelA.visible = not($RacingCanvasLayer/PassageLabelA.visible)
	#$RacingCanvasLayer/PassageLabelB.visible = not($RacingCanvasLayer/PassageLabelB.visible)
	#$RacingCanvasLayer/InitialsBox/RichTextLabelA.visible = not($RacingCanvasLayer/InitialsBox/RichTextLabelA.visible)
	#$RacingCanvasLayer/InitialsBox/RichTextLabelB.visible = not($RacingCanvasLayer/InitialsBox/RichTextLabelB.visible)
	
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
		# TODO: Thread commenting functionallity!
		_enter_thread_comment(event, keystroke, total_keystrokes)

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
				else:
					area_comment[1] = initials
				_save_writing_data()
			#elif self.gameplay_mode == Global.RACING_MODE:
				#pass
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
			
			
func _enter_thread_comment(event: InputEventKey, keystroke : String, total_keystrokes : int):
	pass
	
func _save_writing_data():
	if area_enum == 1:
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 2:
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 3:
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 4:
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.AreaComments, self.area_comment)
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	WorldManager.current_player_area = WorldManager.STAGE_SELECT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
