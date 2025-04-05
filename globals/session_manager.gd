extends Node

const IDLE_SECONDS = 60

var start_timestamp : Dictionary
var end_timestamp : Dictionary
var keystroke_count : int
var reply_count : int

var active_session = false
var timer_running = false
var idle_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_keystroke.connect(_keystroke_session_update)
	add_child(idle_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_running:
		if idle_timer.time_left <= 0:
			# TODO: Should we also have a signal here that triggers the game to go back to stage select if a player is in a gameplay loop?
			end_session()
			
func _keystroke_session_update(event : InputEventKey, keystroke: String, total_keystrokes: int):
	keystroke_count = total_keystrokes
	
	idle_timer.set_wait_time(IDLE_SECONDS)
	idle_timer.start()

func start_session():
	start_timestamp =  Time.get_datetime_dict_from_system()
	keystroke_count = 0
	
	active_session = true
	timer_running = true
	idle_timer.set_wait_time(IDLE_SECONDS)
	idle_timer.one_shot = true
	idle_timer.start()
	

func end_session():
	active_session = false
	timer_running = false
	idle_timer.stop()
	end_timestamp = Time.get_datetime_dict_from_system()

	var start_timestamp_string = Time.get_datetime_string_from_datetime_dict(start_timestamp, false)
	var end_timestamp_string = Time.get_datetime_string_from_datetime_dict(end_timestamp, false)
	
	var unix_start = Time.get_unix_time_from_datetime_dict(start_timestamp)
	var unix_end = Time.get_unix_time_from_datetime_dict(end_timestamp)
	var session_length = unix_end - unix_start
	
	
	var end_time_string = Time.get_time_string_from_unix_time(unix_end)
	end_time_string = end_time_string.left(end_time_string.length() - 3)
	var hour = int(end_time_string.substr(0, 2))
	if hour == 12:
		end_time_string += "PM"
	if hour < 12:
		end_time_string += "AM"
	elif hour > 12:
		var converted_hour = hour - 12
		end_time_string = end_time_string.erase(0, 2)
		end_time_string = end_time_string.insert(0, str(converted_hour))
		end_time_string += "PM"
	
	# Add to world data
	# TODO: Need to get player initial data to here
	var play_feed_string = end_time_string + " - " + str(keystroke_count) + " keystrokes pressed"
	WorldManager.update_player_count()
	WorldManager.update_play_history(play_feed_string)
	
	var session_dict = {
		"session_start" : start_timestamp_string,
		"session_end" : end_timestamp_string,
		"session_length_seconds" : session_length,
		"keystroke_count" : keystroke_count,
		"reply_count" : reply_count,
	}
	
	SignalBus.save_session.emit(session_dict)
