extends Node

var Fireball = preload("res://scenes/racing/fireball_hazard.tscn")

@onready var timer = $Timer

@export var target_player : CharacterBody2D

var rng = RandomNumberGenerator.new()

var current_overworld_chunk : TileMapLayer
var thought_path_coordinates : Array

func initalize(overworld_chunk : TileMapLayer):
	current_overworld_chunk = overworld_chunk
	thought_path_coordinates = overworld_chunk.thought_path_coordinates

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = rng.randf_range(5.0, 10.0)  # TODO: Magic numbers here, needs to be balanced
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	# Get spawn location 
	if target_player.player_locked == false: # If player is not active on track, don't want to spawn hazards
		var player_position = target_player.current_overworld_tile_coords
		var player_position_index = self.thought_path_coordinates.find(player_position)
		var pathing = self.thought_path_coordinates.slice(player_position_index, self.thought_path_coordinates.find(player_position) + 15)
		
		pathing.reverse()
		
		# Create object
		var new_hazard = Fireball.instantiate()
		new_hazard.current_overworld_chunk = current_overworld_chunk
		new_hazard.pathing = pathing
		new_hazard.position = current_overworld_chunk.map_to_local(pathing[0])
		# TODO: Hacky way of implementing double screens... 
		# Better way would be more fine tuned control over coordinate space?
		if current_overworld_chunk.name == "OverworldChunkA":
			new_hazard.screen_position = "A"
		if current_overworld_chunk.name == "OverworldChunkB":
			new_hazard.screen_position = "B"
			new_hazard.position = Vector2(new_hazard.position.x, new_hazard.position.y + 544)
		add_child(new_hazard)
		
		timer.wait_time = rng.randf_range(5.0, 15.0)  # TODO: Magic numbers here, needs to be balanced
		timer.start()
