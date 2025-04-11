extends TileMapLayer

const CHUNK_SIZE = 600
const COMPLETED_KEYSTROKE_TILE_OFFSET = 3

var walkable_tiles : Dictionary = {}
var overworld_input_mapping : Dictionary = {}

var thread : Thread

# Shared Variables
var rng = RandomNumberGenerator.new()
# TODO: Interrogate this solution for storing back coordinates
var stepped_upon_tiles : Array = [null]
var starting_cell_coordinate : Vector2i
var current_ending_cell_coordinate : Vector2i
var astar_width = 10
var thought_path_coordinates : Array

# Thought Racing Variables
var thought_path_passage : String
var forward_steps = 0 


# DEBUG: All of these defaulting to a value for debugging purposes
#var gameplay_mode = self.WRITING_MODE
var gameplay_mode = Global.RACING_MODE
#var thought_path_passage = "Well I want to write a new story about my day. At least I wasen't panicked when the saving didn't work! In many ways I have had a lot of smug joy recently, I mean even being able to play magic makes me content enough! Well I want to write a new story about my day. At least I wasen't panicked"
var shared_atlas_id = 0
var area_atlas_id = 1

func generate_level_chunk(start_cell_coordinate : Vector2i):
	rng.randomize()
	
	var noise = FastNoiseLite.new()
	var k = 0
	
	var starting_cell_x = start_cell_coordinate.x
	var checkpoints : Array = [start_cell_coordinate]
	var astar_path : Array = []
	
	var astargrid = AStarGrid2D.new()
	astar_width += CHUNK_SIZE
	astargrid.size = Vector2i(astar_width, 16)
	astargrid.cell_size = Vector2i(Global.TILE_SIZE, Global.TILE_SIZE)
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()
	
	noise.seed = rng.randf_range(0, 999999)
	noise.fractal_octaves = 2
	noise.fractal_lacunarity = 1.4
	
	# TODO: Should moving between split paths be a gameplay mechanic?
	for x in range(starting_cell_x, (starting_cell_x + CHUNK_SIZE)):
		for y in range(1, 7):
			var curr_vector = Vector2i(x, y)
			var astar_checkpoint_chance = rng.randi_range(0,50)
			if astar_checkpoint_chance == 0:
				checkpoints.append(curr_vector)
				if len(checkpoints) >= 2:
					astar_path.pop_back()
					astar_path += astargrid.get_id_path(checkpoints[-2], checkpoints[-1])
					# TODO: Investigate, Removes dead ends?
					# The idea is that if you never retrace steps in search, then no dead ends
					for coordinate in astar_path:
						astargrid.set_point_solid(coordinate, true)
	
	current_ending_cell_coordinate = astar_path[-1]
	# Create an empty thought path
	for coordinate in astar_path:
		set_cell(coordinate, area_atlas_id, Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[KeyboardInterface.Space], 0)
		
	# Once thought path is created, create a map around it
	for x in range(starting_cell_x - 10, (starting_cell_x + CHUNK_SIZE)):
		for y in range(0, 14):
			if Vector2i(x, y) in self.get_used_cells():
				continue
			k = noise.get_noise_2d(x, y)
			if k < -0.2:
				if area_atlas_id == 1:
					# joy
					set_cell(Vector2(x, y), area_atlas_id, Vector2(rng.randi_range(1, 2), 6), 0)
				elif area_atlas_id == 2:
					# sadness
					set_cell(Vector2(x, y), area_atlas_id, Vector2(1, 6), 0)
				elif area_atlas_id == 3:
					# fear
					set_cell(Vector2(x, y), area_atlas_id, Vector2(rng.randi_range(1, 2), 6), 0)
				elif area_atlas_id == 4:
					# anger
					set_cell(Vector2(x, y), area_atlas_id, Vector2(1, 6), 0)
			elif k > 0.3:
				if area_atlas_id == 1:
					# joy
					set_cell(Vector2(x, y), area_atlas_id, Vector2(3, 6), 0)
				elif area_atlas_id == 2:
					# sadness
					set_cell(Vector2(x, y), area_atlas_id, Vector2(2, 6), 0)
				if area_atlas_id == 3:
					# fear
					set_cell(Vector2(x, y), area_atlas_id, Vector2(3, 6), 0)
				elif area_atlas_id == 4:
					# anger
					set_cell(Vector2(x, y), area_atlas_id, Vector2(1, 6), 0)
			else:
				set_cell(Vector2(x, y), shared_atlas_id, Vector2(rng.randi_range(0, 2), rng.randi_range(0, 1)), 0)
	return astar_path

# TODO: Some sort of error thrown when thought_path_passage size > thought_path_coordinates size
func write_existing_passage():
	self.thought_path_coordinates.append(Vector2i(self.thought_path_coordinates[-1].x+1, self.thought_path_coordinates[-1].y))
	for i in range(0, len(self.thought_path_passage)):
		var char_at_index = thought_path_passage[i]
		var coords_at_index = self.thought_path_coordinates[i+1]
		#print("Char at index " + str(i) + ": " + str(char_at_index))
		#print("Corresponding path coordinates: " + str(coords_at_index))
		if char_at_index in Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM.keys():
			set_cell(coords_at_index, area_atlas_id, Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[char_at_index], 0)
		else:
			set_cell(coords_at_index, area_atlas_id, Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[KeyboardInterface.Space], 0)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_moved_tiles.connect(_on_player_moved_tiles)
	#SignalBus.player_keystroke.connect(_chunk_event_handler)
	
	# Threading
	thread = Thread.new()
	
	if gameplay_mode == Global.WRITING_MODE:
		starting_cell_coordinate = Vector2i(1, rng.randi_range(1, 7))
		self.thought_path_coordinates = generate_level_chunk(starting_cell_coordinate)
	elif gameplay_mode == Global.RACING_MODE:
		starting_cell_coordinate = Vector2i(1, rng.randi_range(1, 7))
		self.thought_path_coordinates = generate_level_chunk(starting_cell_coordinate)
		write_existing_passage()


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
	if next_tile_coords == stepped_upon_tiles[-1]:  # Player is trying to move backwards
		stepped_upon_tiles.pop_back()
		
		if keystroke == KeyboardInterface.Backspace:
			self.set_cell(next_tile_coords, self.area_atlas_id, Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[KeyboardInterface.Space], 0)
	else:
		stepped_upon_tiles.append(prev_tile_coords)
		
		# Update tiles
		if keystroke in Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM.keys():
			self.set_cell(prev_tile_coords, self.area_atlas_id, Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[keystroke], 0)
	SignalBus.update_writing_progress.emit(stepped_upon_tiles.size())

func racing_place_complete_tile(prev_tile_coords : Vector2i, next_tile_coords : Vector2i, keystroke : String):
	if keystroke in Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM.keys():
		var keystroke_atlas_coordinate = Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[keystroke]
		var atlas_offset = 0
		if keystroke != KeyboardInterface.Space:
			atlas_offset = 3
		var completed_keystroke_tile_coordinate = Vector2(keystroke_atlas_coordinate.x, keystroke_atlas_coordinate.y + atlas_offset)
		self.set_cell(next_tile_coords, self.area_atlas_id, completed_keystroke_tile_coordinate, 0)
		forward_steps += 1
	elif keystroke == KeyboardInterface.Backspace:
		var prev_tile_input_val = self.get_cell_tile_data(prev_tile_coords).get_custom_data("input_value")
		var keystroke_atlas_coordinate = Global.INPUT_MAP_LAYER_ATLAS_COORDINATE_ENUM[prev_tile_input_val]
		self.set_cell(prev_tile_coords, self.area_atlas_id, keystroke_atlas_coordinate, 0)
		forward_steps -= 1
		
	var curr_coordinate_index = self.thought_path_coordinates.find(next_tile_coords)
	var completion_ratio = float(curr_coordinate_index) / float(len(self.thought_path_passage))
	var completion_percentage = completion_ratio * 100
	SignalBus.update_racing_progress.emit(completion_percentage)
	
	# TODO: Tech Debt!! Logic for ending game loops is split around the code
	# This also needs some more testing for robustness in general
	if forward_steps == thought_path_passage.length():
		print("Reached the end of a passage")
		SignalBus.racing_complete.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
