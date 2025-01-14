extends TileMapLayer
class_name OverworldLayer

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
