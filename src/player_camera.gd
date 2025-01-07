@tool
extends Camera2D

@export var screen_size = Vector2(1920, 1080)
@export var player : Node2D
var start_offset_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	start_offset_position = global_position

func _physics_process(delta):
	update_camera()

# TODO: I think camera jitters because whenever player moves the camera MUST move, then adjusts itself
# I could expand / modify this function to be world based instead of player based?
func update_camera():
	var current_cell = ((player.global_position - start_offset_position) / screen_size).floor()
	global_position = start_offset_position + (current_cell * screen_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
