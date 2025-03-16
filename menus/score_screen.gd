extends Node

var area_enum : int
var passage : String

var initials = ""
var initials_size = 0

func load_score_screen(area_enum: int, passage: String):
	self.area_enum = area_enum
	self.passage = passage
	$CanvasLayer/PassageLabel.text = passage

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var keystroke = KeyboardInterface.handle_input_event(event)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_enter_initials)


func _enter_initials(event: InputEventKey, keystroke : String, total_keystrokes : int):
	if KeyboardInterface.is_input_event_printable(event):
		if initials_size < 3:
			initials += keystroke.capitalize() + " "
			$CanvasLayer/InitialsBox/RichTextLabel.text = initials
			initials_size += 1
	else:
		if keystroke == KeyboardInterface.Backspace:
			$CanvasLayer/InitialsBox/RichTextLabel.text = ""
			initials_size = 0
		if keystroke == KeyboardInterface.Enter:
			_save_writing_data()
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
func _process(delta):
	pass
