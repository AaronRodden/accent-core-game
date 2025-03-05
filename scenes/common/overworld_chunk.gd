extends TileMapLayer

var walkable_tiles : Dictionary = {}
var overworld_input_mapping : Dictionary = {}

# TODO: Interrogate this solution for storing back coordinates
var stepped_upon_tiles : Array = [null]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_moved_tiles.connect(_on_player_moved_tiles)
	
	var all_cells = get_used_cells()
	for cell_coordinate : Vector2i in all_cells:
		var cell_data = get_cell_tile_data(cell_coordinate)
		if cell_data.get_custom_data("walkable"):
			self.walkable_tiles[cell_coordinate] = cell_data
			if cell_data.get_custom_data("input_value"):
				self.overworld_input_mapping[cell_coordinate] = cell_data.get_custom_data("input_value")

# Given a coordinate, gives all valid movement in coordinate : cell_data form
func get_valid_movement(cell_coordinate : Vector2i):
	var valid_movement_coords = {}
	var target_tile_coords
	for y in 3:
		for x in 3: 
			target_tile_coords = cell_coordinate + Vector2i(x-1, y-1) 
			var target_tile_data : TileData = get_cell_tile_data(target_tile_coords)
			
			if target_tile_data == null:
				continue
			
			if cell_coordinate == target_tile_coords:
				continue
			
			if target_tile_data.get_custom_data("walkable"):
				valid_movement_coords[target_tile_coords] = target_tile_data
	return valid_movement_coords
				
func get_cardinal_movement(cell_coordinate : Vector2i):
	var forwards_backwords_dict = {"forward": null, "backward": null}
	var directions = [Vector2i(-1, 0), Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1)]  # Left, up, right, down

	for direction in directions:
		var cardinal_cell = cell_coordinate + direction
		var cell_data = get_cell_tile_data(cardinal_cell)
		if cell_data:  # skip non rendered tiles
			if cell_data.get_custom_data("walkable") and stepped_upon_tiles[-1] != cardinal_cell:
				forwards_backwords_dict["forward"] = cardinal_cell
			if stepped_upon_tiles[-1] == cardinal_cell:
				forwards_backwords_dict["backward"] = cardinal_cell
	return forwards_backwords_dict

func _on_player_moved_tiles(prev_tile_coords : Vector2i, next_tile_coords : Vector2i, keystroke : String):
	var prev_tile_data = get_cell_tile_data(prev_tile_coords)
	var next_tile_data = get_cell_tile_data(next_tile_coords)
	
	if next_tile_coords == stepped_upon_tiles[-1]:  # Player is trying to move backwards
		stepped_upon_tiles.pop_back()
	else:
		stepped_upon_tiles.append(prev_tile_coords)
		
		# Update tiles
		if keystroke in Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM.keys():
			self.set_cell(prev_tile_coords, 3, Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[keystroke], 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
