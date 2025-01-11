extends TileMapLayer
class_name OverworldLayer

#var current_player_tile : Vector2i

var OverworldInputMapping : Dictionary = {}  # Dict with structure: {Vector2i, String}

func get_input_val(overworld_coords: Vector2i):
	return OverworldInputMapping[overworld_coords]

func get_valid_movement(current_overworld_coords: Vector2i):
	var valid_movement_coords = {}
	var target_tile_coords
	for y in 3:
		for x in 3: 
			target_tile_coords = current_overworld_coords + Vector2i(x-1, y-1)
			
			if current_overworld_coords == target_tile_coords:
				continue
			
			if OverworldInputMapping.has(target_tile_coords):
				valid_movement_coords[target_tile_coords] = get_input_val(target_tile_coords)
	return valid_movement_coords

# Checks the 15 tiles to the left, above, and right of target tile in order to avoid adjacancy issues
func check_adjacancy(overworld_coords: Vector2i):
	var valid_movement_coords = {}
	var target_tile_coords
	for y in 3:
		for x in 5:
			target_tile_coords = overworld_coords + Vector2i(x-2, y-2)
			if overworld_coords == target_tile_coords:
				continue 
				
			if OverworldInputMapping.has(target_tile_coords):
				valid_movement_coords[target_tile_coords] = get_input_val(target_tile_coords)
	return valid_movement_coords

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	## Signals and connections
	#SignalBus.player_moved_tiles.connect(_on_player_moved_tiles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#func _on_player_moved_tiles(overworld_tile_coords: Vector2i):
	#current_player_tile = overworld_tile_coords
	#var overworld_tile_data = get_cell_tile_data(current_player_tile)
	#if overworld_tile_data.get_custom_data("exit_tile"):
		#handle_exit_tile_event(current_player_tile)
		#
#func handle_exit_tile_event(exit_tile_coords: Vector2i):
	#print("on exit tile!")
	#var valid_movement = get_valid_movement(exit_tile_coords)
	#var adjacent_exit_tiles = []
	#for tile_coords in valid_movement:
		#var tile_data = get_cell_tile_data(tile_coords)
		#if tile_data.get_custom_data("exit_tile"):
			#adjacent_exit_tiles.append(tile_coords)
	##print(adjacent_exit_tiles)
