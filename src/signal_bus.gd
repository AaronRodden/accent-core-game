extends Node

# Main signals
signal timer_update(current_timer_value: int)
signal endgame(endgame_type: String)
signal add_player_to_chunk(player : Player, target_chunk : OverworldChunk)

# Player signals
signal player_moved_tiles(current_overworld_coords: Vector2i)
signal player_overworld_chunk_sync(target_oveworld_chunk: OverworldChunk)

# OverworldChunk signals
signal exit_tile_event(exit_direction: Vector2i, target_overworld_chunk: OverworldChunk)

# Resource signals
signal resource_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
