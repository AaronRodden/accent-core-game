extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const TILE_SIZE = Global.TILE_SIZE
const ANIMATION_SPEED = 5

var moving = false

var player_id : String
var current_overworld_layer : OverworldLayer
var current_overworld_tile_coords : Vector2i

func init(player_str: String, overworld_layer: OverworldLayer):
	player_id = player_str
	current_overworld_layer = overworld_layer

func _process(delta):
	pass
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed:
			if moving:
				return
			var valid_movement = current_overworld_layer.get_valid_movement(current_overworld_tile_coords)
			for valid_coord in valid_movement:
				var valid_input = valid_movement[valid_coord]
				if event.as_text_key_label().to_lower() == valid_input:
					print(event.as_text_key_label())
					print("Match!")
					print("Move to: " + str(valid_coord))
					move(current_overworld_tile_coords, valid_coord)

func move(current_coord: Vector2i, target_coord: Vector2i):	
	var position_delta : Vector2 = target_coord - current_coord
	# Tween movement
	var tween = create_tween()
	tween.tween_property(self, "position", 
	   position + position_delta * TILE_SIZE, 1.0/ANIMATION_SPEED).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	# No tween movement
	#position += position_delta * TILE_SIZE
	
	# TODO: We have to fix the position because the scaling! How can we avoid this!
	var fixed_position = Vector2i(position.x/4, position.y/4)	
	current_overworld_tile_coords = current_overworld_layer.local_to_map(fixed_position)
	
func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
	
	# TODO: We have to fix the position because the scaling! How can we avoid this!
	var fixed_position = Vector2i(position.x/4, position.y/4)
	current_overworld_tile_coords = current_overworld_layer.local_to_map(fixed_position)


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