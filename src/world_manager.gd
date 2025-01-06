extends Node

@onready var overworld_map : OverworldLayer = $OverwoldLayer
@onready var input_map : TileMapLayer = $InputMapLayer

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_tile_zero_cells = overworld_map.get_used_cells()
	var walkable_tiles_coords = []
	for tile_coords in all_tile_zero_cells: 
		var tile = overworld_map.get_cell_tile_data(tile_coords)
		if tile.get_custom_data("walkable"):
			walkable_tiles_coords.append(tile_coords)
	
	for overworld_tile_coords in walkable_tiles_coords:
		# TODO: This is completly random right now... but this will not suffice! We need to make sure
		# that there are not identicle letters next to each other!
		var valid_input_cell_atlas_coords = get_valid_input_cell_atlas_coords()
		var valid_input_cell_value = Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[valid_input_cell_atlas_coords]
		overworld_map.OverworldInputMapping[overworld_tile_coords] = valid_input_cell_value
		input_map.set_cell(overworld_tile_coords, 0, valid_input_cell_atlas_coords, 0)  # Set overworld cells with an input map cell 
		
	# Update the global map variable
	Global.overworld_map = overworld_map

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # DEBUG stop
	#for overworld_tile_coords in overworld_map.OverworldInputMapping:
		#var overworld_tile_input_value = overworld_map.get_input_val(overworld_tile_coords)
		#print(overworld_tile_coords)
		#print(overworld_tile_input_value)
	#print(overworld_map.get_valid_movement(Vector2i(1,1)))
	pass # DEBUG stop
	
func get_valid_input_cell_atlas_coords():
	var atlas_row : int = randi_range(10, 12)
	var atlas_col : int
	if atlas_row == 10:
		atlas_col = randi_range(17, 26)
	elif atlas_row == 11:
		atlas_col = randi_range(18, 26)
	elif atlas_row == 12:
		atlas_col = randi_range(19, 25)
	return Vector2i(atlas_col, atlas_row)
