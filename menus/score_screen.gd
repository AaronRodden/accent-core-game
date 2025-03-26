extends Node

var gameplay_mode : int
var area_enum : int
var passage : String

var text_box_location = Vector2(112, 96)

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

	elif gameplay_mode == Global.RACING_MODE:
		self.passage = dynamic_area_data[WorldManager.CurrAreaPassage]
		$WritingCanvasLayer.visible = false
		$RacingCanvasLayer.visible = true
		
		$RacingCanvasLayer/PassageLabel.visible = true
		$RacingCanvasLayer/PassageLabel.text = self.passage
		
		$RacingCanvasLayer/InitialsBox/RichTextLabel.visible = true
		$RacingCanvasLayer/InitialsBox/RichTextLabel.text = dynamic_area_data[WorldManager.CurrAreaPassageAuthor]
		
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
	SignalBus.player_keystroke.connect(_enter_initials)


func _enter_initials(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		if initials_size < 3:
			initials += keystroke.capitalize() + " "
			$WritingCanvasLayer/InitialsBox/RichTextLabel.text = initials
			initials_size += 1
	else:
		if keystroke == KeyboardInterface.Backspace:
			$WritingCanvasLayer/InitialsBox/RichTextLabel.text = ""
			initials_size = 0
		if keystroke == KeyboardInterface.Enter:
			if self.gameplay_mode == Global.RACING_MODE:
				_save_writing_data()
			#elif self.gameplay_mode == Global.WRITING_MODE:
				#pass
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
func _save_writing_data():
	if area_enum == 1:
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 2:
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 3:
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 4:
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.CurrAreaPassage, self.passage)
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	WorldManager.current_player_area = WorldManager.STAGE_SELECT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
