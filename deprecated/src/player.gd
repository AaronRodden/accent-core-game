extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const TILE_SIZE = Global.TILE_SIZE
const ANIMATION_SPEED = 5

var moving = false
var capslock = false

var player_id : String
var current_overworld_chunk : OverworldChunk
var current_overworld_tile_coords : Vector2i

func init(player_str: String, overworld_chunk: OverworldChunk):
	player_id = player_str
	current_overworld_chunk = overworld_chunk
	SignalBus.player_overworld_chunk_sync.emit(current_overworld_chunk)

func _process(delta):
	pass
	
# TODO: This function is a bit overloaded in concept right now.
# We have multiple ways we need to move for the different gameplay loops,
# How will we handle the same input event for these different game loops!
func _unhandled_input(event):
	var capital_case = false
	if event is InputEventKey:
		SignalBus.player_keystroke.emit(event)
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed:
			var physical_key = translate_physical_key(event)
			if moving:
				return
			if physical_key == "capslock":
				capslock = !capslock
				
			# TODO: How should we determine the next place to go in the path!!
			#var valid_movement = current_overworld_chunk.overworld_map.get_valid_movement(current_overworld_tile_coords)
			var valid_movement = current_overworld_chunk.overworld_map.get_forward_movement(current_overworld_tile_coords)
			print(current_overworld_tile_coords)
			print(valid_movement)
			# TODO: We can't loop through the valid movements like this! We need exaclty one/two and choose!
			for valid_coord in valid_movement: 
				var valid_input = valid_movement[valid_coord]
				
				if len(physical_key) == 1: # TODO: Hack to check if a keypress should be rendered
					current_overworld_chunk.overworld_map.treaded_tiles.append(current_overworld_tile_coords)
					move(current_overworld_tile_coords, valid_coord, physical_key, capital_case)
				
				## TODO: More elegent way to do this shift functionallity?
				#if physical_key.to_lower() == valid_input:
					## TODO: This breaks down a bit with numbers...
					## Have to add an extra case to cover for it...
					#if capslock or physical_key == physical_key.to_upper() and physical_key.is_valid_int() == false:
						#capital_case = true
					#move(current_overworld_tile_coords, valid_coord, capital_case)
					#break # Move has already happened, no reason to check other keys

func translate_physical_key(input_event : InputEventKey):
	var keystroke = OS.get_keycode_string(input_event.get_keycode_with_modifiers()).to_lower()
	# TODO: NumLock will change the behavior of the keypad keys
	
	# Keypad 
	if keystroke == "insert":
		keystroke = "0"
	elif keystroke == "end":
		keystroke = "1"
	elif keystroke == "down":
		keystroke = "2"
	elif keystroke == "pagedown":
		keystroke = "3"
	elif keystroke == "left":
		keystroke = "4"
	elif keystroke == "clear":
		keystroke = "5"
	elif keystroke == "right":
		keystroke = "6"
	elif keystroke == "home":
		keystroke = "7"
	elif keystroke == "up":
		keystroke = "8"
	elif keystroke == "pageup":
		keystroke = "9"
	# Punctuation
	if keystroke == "shift+slash":
		keystroke = "?"
	elif keystroke == "shift+1":
		keystroke = "!"
	elif keystroke == "period":
		keystroke = "."
	# Special Keys
	if keystroke == "capslock":
		keystroke = "capslock"
	# Shift keys
	if keystroke.contains("shift") and keystroke.contains("+"):
		keystroke = str(keystroke[-1]).to_upper()
	return keystroke

func move(current_coord: Vector2i, target_coord: Vector2i, keypress: String, capital_case: bool):	
	var position_delta : Vector2 = target_coord - current_coord
	# Tween movement
	#var tween = create_tween()
	#tween.tween_property(self, "position", 
	   #position + position_delta * TILE_SIZE, 1.0/ANIMATION_SPEED).set_trans(Tween.TRANS_SINE)
	#moving = true
	#await tween.finished
	#moving = false
	# No tween movement
	position += position_delta * TILE_SIZE
	current_overworld_tile_coords = current_overworld_chunk.overworld_map.local_to_map(position)
	SignalBus.player_moved_tiles.emit(current_overworld_tile_coords, keypress, capital_case)
	
func exit_tile_move(exit_vector: Vector2, target_overworld_chunk: OverworldChunk):
	# Transition between chunks positionally
	position += exit_vector * TILE_SIZE
	var out_of_chunk_coord = current_overworld_chunk.overworld_map.local_to_map(position)
	var target_chunk_starting_coord = Vector2(posmod(out_of_chunk_coord.x, 30), posmod(out_of_chunk_coord.y, 17))
	position = target_overworld_chunk.overworld_map.map_to_local(target_chunk_starting_coord)
	
	# Add player node to target chunk sceen
	SignalBus.add_player_to_chunk.emit(self, target_overworld_chunk)
	
	# Update variables
	current_overworld_chunk = target_overworld_chunk
	current_overworld_tile_coords = target_chunk_starting_coord
	
	
func _ready():
	# Signals and connections
	SignalBus.exit_tile_event.connect(exit_tile_move)
	
	if current_overworld_chunk:
		current_overworld_tile_coords = current_overworld_chunk.overworld_map.local_to_map(position)

func _physics_process(delta):
	pass
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
