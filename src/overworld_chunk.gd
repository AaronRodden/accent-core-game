extends Node2D
class_name OverworldChunk

const LOCAL_COORD_SPACE_X_MAX = 30
const LOCAL_COORD_SPACE_Y_MAX = 17

var ResourceArrow = preload("res://src/resource_arrow.tscn")

var player_node : Player
var current_player_position : Vector2i
var current_player_tile : Vector2i

@onready var overworld_map : OverworldLayer = $OverworldMapLayer
@onready var input_map : TileMapLayer = $InputMapLayer

@export var chunk_coordinate : String
@export var north_neighbor : OverworldChunk
@export var south_neighbor : OverworldChunk
@export var east_neighbor : OverworldChunk
@export var west_neighbor : OverworldChunk

var walkable_tiles_coords = []
var exit_tiles_coords = {}
var global_resource_locations = []

func compare_y(a, b): 
	return a.y < b.y  

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and connections
	SignalBus.add_player_to_chunk.connect(_player_connect)
	 
	# Overworld creation set-up
	var all_tile_zero_cells = overworld_map.get_used_cells()
	walkable_tiles_coords = []
	for tile_coords in all_tile_zero_cells: 
		var tile = overworld_map.get_cell_tile_data(tile_coords)
		if tile.get_custom_data("walkable"):
			walkable_tiles_coords.append(tile_coords)
	# NOTE: Imperative that this sorting happens for adjacancy checking
	walkable_tiles_coords.sort_custom(compare_y)  
	
	var all_input_map_set_tiles = input_map.get_used_cells()
	
	# DEBUG
	if self.chunk_coordinate == "Hub2":
		pass
	
	# Overworld creation 
	for overworld_tile_coords in walkable_tiles_coords:
		var valid_input_cell_atlas_coords : Vector2i
		# Exit tile detection
		var overworld_tile_data = overworld_map.get_cell_tile_data(overworld_tile_coords)
		if overworld_tile_data.get_custom_data("exit_tile"):
			valid_input_cell_atlas_coords = get_valid_exit_cell_atlas_coords()
			#exit_tiles_coords.append(overworld_tile_coords)
			# TODO: Use constants for the min/max row/col info...
			# TODO: How do we resolve how corner tiles work?
			if overworld_tile_coords.x == 0:
				exit_tiles_coords[overworld_tile_coords] = "west"
			elif overworld_tile_coords.x == 29:
				exit_tiles_coords[overworld_tile_coords] = "east"
			elif overworld_tile_coords.y == 0:
				exit_tiles_coords[overworld_tile_coords] = "north"
			elif overworld_tile_coords.y == 16:
				exit_tiles_coords[overworld_tile_coords] = "south"
		if overworld_tile_coords in all_input_map_set_tiles:
			var input_tile_data = input_map.get_cell_tile_data(overworld_tile_coords)
			var input_value = input_tile_data.get_custom_data("input_value")
			overworld_map.OverworldInputMapping[overworld_tile_coords] = input_value
		else:
			## Short algorithm to ensure adjacent tiles do not share input values
			var valid_movement = overworld_map.check_adjacancy(overworld_tile_coords)
			var adjacent_input_values = []
			for coords in valid_movement:  # Extract input values from adjacent squares 
				adjacent_input_values.append(valid_movement[coords])
			valid_input_cell_atlas_coords = get_valid_input_cell_atlas_coords(adjacent_input_values)
		
			# Assign valid input value to a given square on the overworld 
			var valid_input_cell_value = Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[valid_input_cell_atlas_coords]
			overworld_map.OverworldInputMapping[overworld_tile_coords] = valid_input_cell_value # Sets the cell in data
			input_map.set_cell(overworld_tile_coords, 0, valid_input_cell_atlas_coords, 0) # Visually sets the cell
			
	# Update the global variables and position information
	
	# Place player on a valid tile
	current_player_position = overworld_map.map_to_local(overworld_map.OverworldInputMapping.keys()[0])
	current_player_tile = overworld_map.OverworldInputMapping.keys()[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func get_valid_input_cell_atlas_coords(adjacent_input_values):
	var atlas_row : int
	var atlas_col : int
	while true:  # Continue searching for valid atlas coord until you find a valid one
		atlas_row = randi_range(10, 12)
		if atlas_row == 10:
			atlas_col = randi_range(17, 26)
		elif atlas_row == 11:
			atlas_col = randi_range(18, 26)
		elif atlas_row == 12:
			atlas_col = randi_range(19, 25)
		if not adjacent_input_values.has(Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[Vector2i(atlas_col, atlas_row)]):
			break
	return Vector2i(atlas_col, atlas_row)
	
func get_valid_exit_cell_atlas_coords():
	var random_punctuation = randi_range(0,2)
	match random_punctuation:
		0:
			return Vector2i(31,9) # !
		1: 
			return Vector2i(28,12) # ?
		2: 
			return Vector2i(27,13) # .

func get_atlas_coord_from_keystoke(keystroke: String):
	var atlas_coord = Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM.find_key(keystroke)
	return atlas_coord

func _player_connect(player: Player, target_overworld_chunk: OverworldChunk):
	if self.name == target_overworld_chunk.name:
		add_child(player)
		player_node = player
		SignalBus.player_moved_tiles.connect(_on_player_moved_tiles)
		
func _player_disconnect():
	remove_child(player_node)
	SignalBus.player_moved_tiles.disconnect(_on_player_moved_tiles)

func _on_player_moved_tiles(overworld_tile_coords: Vector2i, keypress: String, capital_case: bool):
	var previous_player_tile = current_player_tile
	# DEBUG: Erasing previous tiles after walking on them
	#print("Previous: " + str(previous_player_tile))
	current_player_tile = overworld_tile_coords
	#print("Current: " + str(current_player_tile))
	#print(capital_case)
	#if capital_case:
		#clear_tile_input_map(previous_player_tile)
	input_map.set_cell(previous_player_tile, 0, get_atlas_coord_from_keystoke(keypress), 0)
	
	var overworld_tile_data = overworld_map.get_cell_tile_data(current_player_tile)
	# TODO: Do an adjaceny check for any event tiles
	var adjacent_tiles_data = overworld_map.get_adjacent_tile_data(current_player_tile)
	for adjacent_coord in adjacent_tiles_data:
		var adjacent_tile_data = adjacent_tiles_data[adjacent_coord]
		if adjacent_tile_data:  # Don't look at out of bounds tiles
			if adjacent_tile_data.get_custom_data("navigation_tile"):
				handle_navigation_tile_event(adjacent_coord)
			if adjacent_tile_data.get_custom_data("health_tile"):
				adjacent_tile_data.set_custom_data("health_tile", false)
				SignalBus.health_tile_event.emit()
				adjacent_tile_data.set_modulate(Color(1,1,1,1))
	if overworld_tile_data.get_custom_data("exit_tile"):
		handle_exit_tile_event(current_player_tile)

# BUG: This seems to have been broken in some design exploration
func clear_tile_input_map(overworld_tile_coords: Vector2i):
	var input_atlas_cleared_cell = Vector2i(29, 14) #TODO: Magic number make constant
	input_map.set_cell(overworld_tile_coords, 0, input_atlas_cleared_cell, 0) # Visually sets the cell

# Get distance to EACH resource. Then point an arrow to the closest one.
func handle_navigation_tile_event(current_navigation_tile_coords: Vector2i):
	# Remove any existing arrows
	for N in self.get_children():
		if N.name == "resource_arrow":
			N.free()
	
	var min_distance = INF
	var closest_resource_coords : Vector2
	
	var navigation_tile_global_coords = overworld_map.map_to_local(current_navigation_tile_coords)
	for resource_position in Global.world_resources_global_positions:
		var resource_distance = navigation_tile_global_coords.distance_to(resource_position)
		if resource_distance < min_distance:
			min_distance = resource_distance
			closest_resource_coords = resource_position
	
	var direction_vector = closest_resource_coords - navigation_tile_global_coords
	var rotation_angle = atan2(direction_vector.y, direction_vector.x)
	
	var new_arrow = ResourceArrow.instantiate()
	new_arrow.name = "resource_arrow"
	new_arrow.position = navigation_tile_global_coords
	new_arrow.look_at(closest_resource_coords)
	add_child(new_arrow)

func handle_exit_tile_event(current_exit_tile_coords: Vector2i):
	var neighbor : OverworldChunk
	var exit_vector: Vector2i
	var exit_direction = exit_tiles_coords[current_exit_tile_coords]
	match exit_direction:
		"north":
			neighbor = north_neighbor
			exit_vector = Vector2i(0, -1)
		"east":
			neighbor = east_neighbor
			exit_vector = Vector2i(1, 0)
		"south":
			neighbor = south_neighbor
			exit_vector = Vector2i(0, 1)
		"west":
			neighbor = west_neighbor
			exit_vector = Vector2i(-1, 0)	
	_player_disconnect()
	SignalBus.exit_tile_event.emit(exit_vector, neighbor)

	
	# Check for adjacent exit tiles
	#var valid_movement = overworld_map.get_valid_movement(exit_tile_coords)
	#var adjacent_exit_tiles = []
	#for tile_coords in valid_movement:
		#var tile_data = overworld_map.get_cell_tile_data(tile_coords)
		#if tile_data.get_custom_data("exit_tile"):
			#adjacent_exit_tiles.append(tile_coords)
	#print(adjacent_exit_tiles)
