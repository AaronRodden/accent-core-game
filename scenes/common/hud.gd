extends Control

# TODO: Health connected to HUD is for demo
var current_health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	#Signals and Connections
	SignalBus.player_hit.connect(_reduce_health)

func _reduce_health():
	if current_health == 5:
		$Heart5.visible = false
	elif current_health == 4:
		$Heart4.visible = false
	elif current_health == 3:
		$Heart3.visible = false
	elif current_health == 2:
		$Heart2.visible = false
	elif current_health == 1:
		$Heart1.visible = false
		SignalBus.game_over.emit()
	current_health -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$TotalWords.text = KeyboardInterface.word_count + " / " + KeyboardInterface.word_total + " words" 
	$Word_Info/Keystrokes.text = str(KeyboardInterface.total_keystrokes)
