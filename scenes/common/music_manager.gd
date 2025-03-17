extends Node

@onready var main_music = $MainMusic

var SONG_DICTIONARY = {
	"creative_anger" : "res://assets/music/acreativeexcerciseanger3-14.mp3",
	"creative_fear" : "res://assets/music/acreativeexcercisefear3-14.mp3",
	"creative_joy" : "res://assets/music/acreativeexcercisejoy3-14.mp3",
	"creative_sadness" : "res://assets/music/acreativeexcercisesadness3-14.mp3",
	"racing_anger" : "res://assets/music/RacingDemoAnger3-14.mp3",
	"racing_fear" : "res://assets/music/RacingDemoFear3-14.mp3",
	"racing_joy" : "res://assets/music/RacingDemoJoy3-14.mp3",
	"racing_sadness" : "res://assets/music/RacingDemoSadness3-14.mp3",
	"stage_select" : "res://assets/music/themind3-14.mp3",
}
var current_song

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.scene_change.connect(_load_and_play)
	
	_load_and_play(Global.main, Global.stage_select, 0)

func _load_and_play(prev_scene: String, next_scene: String, area_enum: int):
	match next_scene:
		Global.stage_select:
			current_song = load(SONG_DICTIONARY["stage_select"])
			main_music.set_stream(current_song)
		Global.thought_path_writing:
			match area_enum:
				WorldManager.ANGER_AREA:
					current_song = load(SONG_DICTIONARY["creative_anger"])
					main_music.set_stream(current_song)
				WorldManager.FEAR_AREA:
					current_song = load(SONG_DICTIONARY["creative_fear"])
					main_music.set_stream(current_song)
				WorldManager.JOY_AREA:
					current_song = load(SONG_DICTIONARY["creative_joy"])
					main_music.set_stream(current_song)
				WorldManager.SADNESS_AREA:
					current_song = load(SONG_DICTIONARY["creative_sadness"])
					main_music.set_stream(current_song)
		Global.thought_path_racing:
			match area_enum:
				WorldManager.ANGER_AREA:
					current_song = load(SONG_DICTIONARY["racing_anger"])
					main_music.set_stream(current_song)
				WorldManager.FEAR_AREA:
					current_song = load(SONG_DICTIONARY["racing_fear"])
					main_music.set_stream(current_song)
				WorldManager.JOY_AREA:
					current_song = load(SONG_DICTIONARY["racing_joy"])
					main_music.set_stream(current_song)
				WorldManager.SADNESS_AREA:
					current_song = load(SONG_DICTIONARY["racing_sadness"])
					main_music.set_stream(current_song)
		Global.score_screen:
			current_song = load(SONG_DICTIONARY["stage_select"])
			main_music.set_stream(current_song)
			
	main_music.play()
	main_music.stream.loop = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
