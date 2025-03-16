class_name SaverLoader
extends Node

# NOTE: Great tutorial where I copied this code structure from
# https://www.youtube.com/watch?v=43BZsLZheA4

func _ready():
	# Signals and Connections
	SignalBus.save_game.connect(save_game)
	SignalBus.load_game.connect(load_game)

func save_game():	
	var saved_game : SavedGame = SavedGame.new()
	
	saved_game.world_dynamic_data = WorldManager.world_dynamic_data
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	var saved_game : SavedGame = load("user://savegame.tres") as SavedGame
	
	WorldManager.world_dynamic_data = saved_game.world_dynamic_data
