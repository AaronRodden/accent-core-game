@tool
extends Node2D
class_name OverworldChunk

const CENTER_TILE_COORDS = Vector2(15, 8)
const LOCAL_COORD_SPACE_X_MAX = 30
const LOCAL_COORD_SPACE_Y_MAX = 17

var player_node : Player
var current_player_tile : Vector2i

@onready var overworld_map : OverworldLayer = $OverworldMapLayer
@onready var input_map : TileMapLayer = $InputMapLayer

var center_position : Vector2

@export var chunk_coordinate : String
@export var north_neighbor : OverworldChunk
@export var south_neighbor : OverworldChunk
@export var east_neighbor : OverworldChunk
@export var west_neighbor : OverworldChunk

var walkable_tiles_coords = []
var exit_tiles_coords = {}

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
	
	# Overworld creation 
	for overworld_tile_coords in walkable_tiles_coords:
		var valid_input_cell_atlas_coords : Vector2i
		# Exit tile detection
		var overworld_tile_data = overworld_map.get_cell_tile_data(overworld_tile_coords)
		if overworld_tile_data.get_custom_data("exit_tile"):
			valid_input_cell_atlas_coords = get_valid_exit_cell_atlas_coords()
			#exit_tiles_coords.append(overworld_tile_coords)
			# TODO: Use constants for the min/max row/col info...
			if overworld_tile_coords.x == 0:
				exit_tiles_coords[overworld_tile_coords] = "west"
			elif overworld_tile_coords.x == 29:
				exit_tiles_coords[overworld_tile_coords] = "east"
			elif overworld_tile_coords.y == 0:
				exit_tiles_coords[overworld_tile_coords] = "north"
			elif overworld_tile_coords.y == 16:
				exit_tiles_coords[overworld_tile_coords] = "south"
		else:
			# Short algorithm to ensure adjacent tiles do not share input values
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
	center_position = overworld_map.map_to_local(CENTER_TILE_COORDS)

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

func _player_connect(player: Player, target_overworld_chunk: OverworldChunk):
	if self.name == target_overworld_chunk.name:
		add_child(player)
		player_node = player
		SignalBus.player_moved_tiles.connect(_on_player_moved_tiles)
		
func _player_disconnect():
	remove_child(player_node)
	SignalBus.player_moved_tiles.disconnect(_on_player_moved_tiles)

func _on_player_moved_tiles(overworld_tile_coords: Vector2i):
	current_player_tile = overworld_tile_coords
	var overworld_tile_data = overworld_map.get_cell_tile_data(current_player_tile)
	if overworld_tile_data.get_custom_data("exit_tile"):
		handle_exit_tile_event(current_player_tile)
		
func handle_exit_tile_event(current_exit_tile_coords: Vector2i):
	print("on exit tile!")
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
