extends Node

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

func _play_creative_anger():
	current_song = load(SONG_DICTIONARY["creative_anger"])

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.scene_change.connect(_load_and_play)

func _load_and_play(prev_scene: String, next_scene: String, area_enum: int):
	match next_scene:
		Global.stage_select:
			pass
		Global.thought_path_writing:
			match area_enum:
				WorldManager.ANGER_AREA:
					pass
				WorldManager.FEAR_AREA:
					pass
				WorldManager.JOY_AREA:
					pass
				WorldManager.SADNESS_AREA:
					pass
		Global.thought_path_racing:
			match area_enum:
				WorldManager.ANGER_AREA:
					pass
				WorldManager.FEAR_AREA:
					pass
				WorldManager.JOY_AREA:
					pass
				WorldManager.SADNESS_AREA:
					pass
		Global.score_screen:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
