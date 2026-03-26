class_name SaverLoader
extends Node

# NOTE: Great tutorial where I copied this code structure from
# https://www.youtube.com/watch?v=43BZsLZheA4

var current_date = Time.get_date_dict_from_system()
var datestamp = str(current_date["month"]) + "_" + str(current_date["day"]) + "_" + str(current_date["year"])
var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)

func _ready():
	# Signals and Connections
	SignalBus.save_game.connect(save_game)
	SignalBus.load_game.connect(load_game)
	
	SignalBus.save_session.connect(save_session)

func save_game():
	var saved_game : SavedGame = SavedGame.new()
	
	saved_game.world_dynamic_data = WorldManager.world_dynamic_data
	
	var time = Time.get_time_dict_from_system()
	
	# TODO: Add computer / participant numbers? 
	
	var file_name = "savegame_" + datestamp + ".tres"
	var file_path = desktop_path.path_join(file_name)
	ResourceSaver.save(saved_game, file_path)
	
func load_game():
	var saved_game : SavedGame = load("user://savegame.tres") as SavedGame
	
	WorldManager.world_dynamic_data = saved_game.world_dynamic_data
	
	SignalBus.load_update.emit()


func save_session(session_dictionary : Dictionary):
	var saved_session : SavedSession = SavedSession.new()
	
	saved_session.session_data = session_dictionary
	
	var file_name = "session_data_" + session_dictionary["session_start"].replace(":", "_") + session_dictionary["session_end"].replace(":", "_") + ".tres"
	var file_path = desktop_path.path_join(file_name)
	ResourceSaver.save(saved_session, file_path)
