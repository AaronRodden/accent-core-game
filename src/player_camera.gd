@tool
extends Camera2D

@export var screen_size = Vector2(1920, 1080)
@export var player : Node2D
var start_offset_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and connections
	SignalBus.exit_tile_event.connect(_update_camera)
	
	start_offset_position = global_position

func _physics_process(delta):
	pass

# Update camera when chunk transitions happen
func _update_camera(exit_direction: Vector2, target_overworld_chunk: OverworldChunk):
	# TODO: Zelda 1 style camera transitions?
	offset = target_overworld_chunk.position
