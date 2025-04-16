extends Node

@onready var main_music = $MainMusic

var SONG_DICTIONARY = {
	"creative_anger" : "res://assets/music/AcreativeexcerciseangerFinal.wav",
	"creative_fear" : "res://assets/music/AcreativeexcercisefearFinal.wav",
	"creative_joy" : "res://assets/music/AcreativeexcercisejoyFinal.wav",
	"creative_sadness" : "res://assets/music/acreativeexcercisesadnessFinal.wav",
	"racing_anger" : "res://assets/music/RacingAngerFinal.wav",
	"racing_fear" : "res://assets/music/RacingFearFinal.wav",
	"racing_joy" : "res://assets/music/RacingJoyFinal.wav",
	"racing_sadness" : "res://assets/music/RacingSadnessFinal.wav",
	"stage_select_anger" : "res://assets/music/themindAnger.wav",
	"stage_select_fear" : "res://assets/music/themindAnger.wav",
	"stage_select_joy" : "res://assets/music/themindFear.wav",
	"stage_select_sadness" : "res://assets/music/themindSadness.wav",
	"success" : "res://assets/music/Success!.wav",
}
var current_song

var loop_flag = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.scene_change.connect(_load_and_play)
	
	_load_and_play(Global.main, Global.stage_select, 0)

func _load_and_play(prev_scene: String, next_scene: String, area_enum: int):
	main_music.stop()
	loop_flag = true
	match next_scene:
		Global.stage_select:
			var areas_completed = WorldManager.get_world_data(WorldManager.AreasCompleted)
			if areas_completed < 3:
				current_song = load(SONG_DICTIONARY["stage_select_sadness"])
			elif areas_completed > 3 and areas_completed < 6:
				current_song = load(SONG_DICTIONARY["stage_select_anger"])
			elif areas_completed > 6 and areas_completed < 9:
				current_song = load(SONG_DICTIONARY["stage_select_fear"])
			elif areas_completed > 9:
				current_song = load(SONG_DICTIONARY["stage_select_joy"])
			main_music.set_stream(current_song)
		Global.thought_path_writing:
			match area_enum:
				WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
					current_song = load(SONG_DICTIONARY["creative_anger"])
					main_music.set_stream(current_song)
				WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
					current_song = load(SONG_DICTIONARY["creative_fear"])
					main_music.set_stream(current_song)
				WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
					current_song = load(SONG_DICTIONARY["creative_joy"])
					main_music.set_stream(current_song)
				WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
					current_song = load(SONG_DICTIONARY["creative_sadness"])
					main_music.set_stream(current_song)
		Global.thought_path_racing:
			match area_enum:
				WorldManager.ANGER_AREA_A, WorldManager.ANGER_AREA_B, WorldManager.ANGER_AREA_C:
					current_song = load(SONG_DICTIONARY["racing_anger"])
					main_music.set_stream(current_song)
				WorldManager.FEAR_AREA_A, WorldManager.FEAR_AREA_B, WorldManager.FEAR_AREA_C:
					current_song = load(SONG_DICTIONARY["racing_fear"])
					main_music.set_stream(current_song)
				WorldManager.JOY_AREA_A, WorldManager.JOY_AREA_B, WorldManager.JOY_AREA_C:
					current_song = load(SONG_DICTIONARY["racing_joy"])
					main_music.set_stream(current_song)
				WorldManager.SADNESS_AREA_A, WorldManager.SADNESS_AREA_B, WorldManager.SADNESS_AREA_C:
					current_song = load(SONG_DICTIONARY["racing_sadness"])
					main_music.set_stream(current_song)
		Global.score_screen:
			current_song = load(SONG_DICTIONARY["success"])
			main_music.set_stream(current_song)
			loop_flag = false
			
	main_music.play()
	#main_music.stream.loop = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_music_finished():
	if loop_flag:
		main_music.play()
