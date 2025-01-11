@tool
extends Node
class_name OverworldChunk

@onready var overworld_map : OverworldLayer = $OverworldMapLayer
@onready var input_map : TileMapLayer = $InputMapLayer


func compare_y(a, b): 
	return a.y < b.y  
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and connections
	#SignalBus.player_moved_tiles.connect(_on_player_moved_tiles)
	
	# Overworld creation set-up
	var all_tile_zero_cells = overworld_map.get_used_cells()
	var walkable_tiles_coords = []
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
		#if overworld_tile_data.get_custom_data("exit_tile"):
			#valid_input_cell_atlas_coords = get_valid_exit_cell_atlas_coords()
		#else:
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
		
	# Update the global map variable
	Global.overworld_map = overworld_map


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
