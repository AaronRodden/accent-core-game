extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


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
	pass
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		#if event.pressed and event.keycode == KEY_ESCAPE:
			#get_tree().quit()
		var keystroke = KeyboardInterface.handle_input_event(event)
		if self.game_stance == "writing":
			writing_move(event, keystroke)
		elif self.game_stance == "racing" :
			racing_move(event, keystroke)
		else:
			pass


# TODO: Implement sound effects / notices of end of line?
func writing_move(event : InputEventKey, keystroke : String):
	# Determine forwards / backwords coordinate
	var forwards_backwards = self.current_overworld_chunk.get_cardinal_movement(current_overworld_tile_coords)
	var forwards_coordinate = forwards_backwards["forward"]
	var backwards_coordinate = forwards_backwards["backward"]
	
	# Check if player is trying to go forwards or backwards
	var target_tile_coords
	var target_tile_data
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
	
	SignalBus.player_actionable_keystroke.emit(event, keystroke)
	SignalBus.player_moved_tiles.emit(current_overworld_tile_coords, target_tile_coords, keystroke)
	var position_delta : Vector2 = target_tile_coords - Vector2i(current_overworld_tile_coords.x, current_overworld_tile_coords.y)
	position += position_delta * Global.TILE_SIZE
	current_overworld_tile_coords = current_overworld_chunk.local_to_map(position)


func racing_move(event : InputEventKey, keystroke : String):
	# Determine forwards / backwords coordinate
	#var forwards_backwards = self.current_overworld_chunk.get_cardinal_movement(current_overworld_tile_coords)
	#var forwards_coordinate = forwards_backwards["forward"]
	#var backwards_coordinate = forwards_backwards["backward"]
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
	elif keystroke == KeyboardInterface.Tab:
		# TODO: Passage swapping!
		pass
	else: 
		print("Non-matching or non-actional key pressed...")
		return 
		
	#SignalBus.player_moved_tiles.emit(current_overworld_tile_coords, target_tile_coords, keystroke)
	SignalBus.player_actionable_keystroke.emit(event, keystroke)
	var position_delta : Vector2 = target_tile_coords - Vector2i(current_overworld_tile_coords.x, current_overworld_tile_coords.y)
	position += position_delta * Global.TILE_SIZE
	current_overworld_tile_coords = current_overworld_chunk.local_to_map(position)
	
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
