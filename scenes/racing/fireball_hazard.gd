extends Area2D

var current_overworld_chunk : TileMapLayer
var current_overworld_tile_coords : Vector2i
var target_tile_coords
var pathing : Array
var current_dir : Vector2
var velocity : float
var screen_position : String

var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_overworld_tile_coords = pathing[0]
	target_tile_coords = current_overworld_tile_coords  # Init target tile coords to start animation loop

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_overworld_tile_coords == target_tile_coords:
		target_tile_coords = pathing.pop_front()
		if target_tile_coords == null:
			self.queue_free()
			return
		
		current_dir = target_tile_coords - Vector2i(current_overworld_tile_coords.x, current_overworld_tile_coords.y)
		move()

func move():
	if current_dir and moving == false:
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position+current_dir*Global.TILE_SIZE, 0.35)
		tween.tween_callback(move_false)
		
func move_false():
	moving = false
	if screen_position == "B":
		var corrected_position = Vector2(position.x, position.y - 544)
		current_overworld_tile_coords = current_overworld_chunk.local_to_map(corrected_position)
	else:
		current_overworld_tile_coords = current_overworld_chunk.local_to_map(position)
	

func _on_body_entered(body):
	print("Hit a player!")
	SignalBus.player_hit.emit()
	self.queue_free()
