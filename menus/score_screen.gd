extends Node

var area_enum : int
var passageA : String
var passageB : String

var passageA_text_box_location = Vector2(112, 96)
var passageB_text_box_location = Vector2(136, 64)

var initials = ""
var initials_size = 0

func load_score_screen(gameplay_mode: int, passage : String, area_enum_a: int, area_enum_b : int = -1): 
	var dynamic_area_data_a = WorldManager.get_dynamic_data(area_enum_a)
	var dynamic_area_data_b : Dictionary
	if area_enum_b > 0:
		dynamic_area_data_b = WorldManager.get_dynamic_data(area_enum_b)
	if gameplay_mode == Global.WRITING_MODE:
		$RacingCanvasLayer.visible = false
		$WritingCanvasLayer.visible = true
		self.area_enum = area_enum_a
		self.passageA = passage
		$WritingCanvasLayer/PassageLabel.text = passageA

	elif gameplay_mode == Global.RACING_MODE:
		$WritingCanvasLayer.visible = false
		$RacingCanvasLayer.visible = true
		self.passageA = dynamic_area_data_a[WorldManager.CurrAreaPassage]
		self.passageB = dynamic_area_data_b[WorldManager.CurrAreaPassage]
		
		$RacingCanvasLayer/PassageLabelA.visible = true
		$RacingCanvasLayer/PassageLabelB.visible = false
		$RacingCanvasLayer/PassageLabelA.text = passageA
		$RacingCanvasLayer/PassageLabelB.text = passageB
		
		$RacingCanvasLayer/InitialsBox/RichTextLabelA.visible = true
		$RacingCanvasLayer/InitialsBox/RichTextLabelB.visible = false
		$RacingCanvasLayer/InitialsBox/RichTextLabelA.text = dynamic_area_data_a[WorldManager.CurrAreaPassageAuthor]
		$RacingCanvasLayer/InitialsBox/RichTextLabelB.text = dynamic_area_data_b[WorldManager.CurrAreaPassageAuthor]
		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var keystroke = KeyboardInterface.handle_input_event(event)
		
		if keystroke == KeyboardInterface.Tab:
			_swap_passage_interfaces()

func _swap_passage_interfaces():
	# Swap Story Overview sprite order
	var secondary_story_node_index = $RacingCanvasLayer/StoryOverviewB.get_index()
	if secondary_story_node_index == 0:
		$RacingCanvasLayer.move_child($RacingCanvasLayer/StoryOverviewB, 1)
	else: 
		$RacingCanvasLayer.move_child($RacingCanvasLayer/StoryOverviewA, 1)
	
	# Visiblity swaps
	$RacingCanvasLayer/PassageLabelA.visible = not($RacingCanvasLayer/PassageLabelA.visible)
	$RacingCanvasLayer/PassageLabelB.visible = not($RacingCanvasLayer/PassageLabelB.visible)
	$RacingCanvasLayer/InitialsBox/RichTextLabelA.visible = not($RacingCanvasLayer/InitialsBox/RichTextLabelA.visible)
	$RacingCanvasLayer/InitialsBox/RichTextLabelB.visible = not($RacingCanvasLayer/InitialsBox/RichTextLabelB.visible)
	
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
			_save_writing_data()
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
func _save_writing_data():
	if area_enum == 1:
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassage, self.passageA)
		WorldManager.write_world_data(WorldManager.JOY_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 2:
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassage, self.passageA)
		WorldManager.write_world_data(WorldManager.SADNESS_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 3:
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.CurrAreaPassage, self.passageA)
		WorldManager.write_world_data(WorldManager.FEAR_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	if area_enum == 4:
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.CurrAreaPassage, self.passageA)
		WorldManager.write_world_data(WorldManager.ANGER_AREA, WorldManager.CurrAreaPassageAuthor, self.initials.strip_edges())
		KeyboardInterface.reset()
	WorldManager.current_player_area = WorldManager.STAGE_SELECT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
