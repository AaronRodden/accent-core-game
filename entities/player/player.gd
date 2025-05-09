extends CharacterBody2D

var NeuronSprite : AnimatedSprite2D

const KEYBOARD_SFX = ["res://assets/sfx/Key1final.wav", "res://assets/sfx/Key2final.wav", "res://assets/sfx/Key3final.wav"]

var player_locked = false

var game_stance : String

var current_overworld_chunk : TileMapLayer
var current_overworld_tile_coords : Vector2i

var coordinate_history : Array

func initalize(overworld_chunk : TileMapLayer, game_type : String):
	game_stance = game_type
	current_overworld_chunk = overworld_chunk
	position = current_overworld_chunk.map_to_local(current_overworld_chunk.starting_cell_coordinate)
	current_overworld_tile_coords = current_overworld_chunk.local_to_map(position)

func _ready():
	# Signals and Connections
	SignalBus.player_hit.connect(_player_hit)
	
	var random_color = randi_range(1, 5)
	match random_color:
		1:
			NeuronSprite = $NeuronSpriteBlue
		2:
			NeuronSprite = $AnimatedSpritePurple
		3:
			NeuronSprite = $AnimatedSpriteGreen
		4:
			NeuronSprite = $AnimatedSpriteRed
		5:
			NeuronSprite = $AnimatedSpriteYellow
			
	var random_animation = randi_range(0, 1)
	if random_animation == 0:
		NeuronSprite.play("hop")
	elif random_animation == 1:
		NeuronSprite.play("run")
	
	NeuronSprite.stop()
	NeuronSprite.visible = true 
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		NeuronSprite.play()
		var keystroke = KeyboardInterface.handle_input_event(event)
		var key_sfx
		if keystroke in Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM.keys():
			var keystroke_atlas_coords = Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[keystroke]
			if keystroke == KeyboardInterface.Space:
				key_sfx = load("res://assets/sfx/Space.wav")
			elif keystroke_atlas_coords.y >= 2:
				key_sfx = load("res://assets/sfx/Punctuation.wav")
			else: 
				key_sfx = load(KEYBOARD_SFX.pick_random())
		$KeyboardFx.set_stream(key_sfx)
		$KeyboardFx.play()
		if self.game_stance == "writing":
			writing_move(event, keystroke)
		elif self.game_stance == "racing" :
			racing_move(event, keystroke)
			
			
func _player_hit():
	$HitFx.play()

func lock():
	self.player_locked = true
	self.visible = false
	$CollisionShape2D.disabled = true
	
func unlock():
	self.player_locked = false
	self.visible = true
	$CollisionShape2D.disabled = false

# TODO: Implement sound effects / notices of end of line?
func writing_move(event : InputEventKey, keystroke : String):
	# Determine forwards / backwords coordinate
	var forwards_backwards = self.current_overworld_chunk.get_cardinal_movement(current_overworld_tile_coords)
	var forwards_coordinate = forwards_backwards["forward"]
	var backwards_coordinate = forwards_backwards["backward"]
	
	# Check if player is trying to go forwards or backwards
	var target_tile_coords
	if KeyboardInterface.is_input_event_printable(event):
		target_tile_coords = forwards_coordinate
	else: 
		if keystroke == KeyboardInterface.Backspace:
			target_tile_coords = backwards_coordinate
		if keystroke == KeyboardInterface.Shift:
			print("Non actionable key pressed...")
			return 
	
	# Player Movement
	if target_tile_coords == null:
		print("End of the line...")
		return
	
	SignalBus.player_writing_keystroke.emit(event, keystroke, self)
	SignalBus.player_moved_tiles.emit(current_overworld_tile_coords, target_tile_coords, keystroke)
	var position_delta : Vector2 = target_tile_coords - Vector2i(current_overworld_tile_coords.x, current_overworld_tile_coords.y)
	position += position_delta * Global.TILE_SIZE
	current_overworld_tile_coords = current_overworld_chunk.local_to_map(position)


func racing_move(event : InputEventKey, keystroke : String):
	if not player_locked:
		# Determine forwards / backwords coordinate
		var current_coordinate_index = self.current_overworld_chunk.thought_path_coordinates.find(current_overworld_tile_coords)
		var forwards_coordinate = self.current_overworld_chunk.thought_path_coordinates[current_coordinate_index + 1]
		var backwards_coordinate
		if current_coordinate_index - 1 < 0:
			backwards_coordinate = null
		else:
			backwards_coordinate = self.current_overworld_chunk.thought_path_coordinates[current_coordinate_index - 1]
		
		var forwards_input = self.current_overworld_chunk.get_cell_tile_data(forwards_coordinate).get_custom_data("input_value")
		
		var target_tile_coords
		if keystroke == forwards_input:
			target_tile_coords = forwards_coordinate
		elif keystroke == KeyboardInterface.Backspace:
			target_tile_coords = backwards_coordinate
		else: 
			print("Non-matching or non-actional key pressed...")
			return 
			
		# Check for end of the line
		if target_tile_coords == null:
			print("End of the line...")
			return
			
		
		SignalBus.player_racing_keystroke.emit(event, keystroke, self)  # Racing specific signal emittion
		# Players should modify their specific overworld chunks, hence not using signals for this overworld edit
		self.current_overworld_chunk.racing_place_complete_tile(current_overworld_tile_coords, target_tile_coords, keystroke)
		
		# Movement 
		var position_delta : Vector2 = target_tile_coords - Vector2i(current_overworld_tile_coords.x, current_overworld_tile_coords.y)
		position += position_delta * Global.TILE_SIZE
		current_overworld_tile_coords = current_overworld_chunk.local_to_map(position)
	
