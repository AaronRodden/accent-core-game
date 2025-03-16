extends Control

# TODO: Health connected to HUD is for demo
var current_health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	#Signals and Connections
	SignalBus.player_hit.connect(_reduce_health)

func _reduce_health():
	if current_health == 5:
		$Health_Score/Heart5.visible = false
	elif current_health == 4:
		$Health_Score/Heart4.visible = false
	elif current_health == 3:
		$Health_Score/Heart3.visible = false
	elif current_health == 2:
		$Health_Score/Heart2.visible = false
	elif current_health == 1:
		$Health_Score/Heart1.visible = false
		defeat()
	current_health -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$TotalWords.text = KeyboardInterface.word_count + " / " + KeyboardInterface.word_total + " words" 
	$Word_Info/Keystrokes.text = str(KeyboardInterface.total_keystrokes)


func victory():
	$GameEnd/GameEndText.text = "Victory!!!"
	$GameEnd.visible = true
	
func defeat():
	$GameEnd/GameEndText.text = "Game Over"
	$GameEnd.visible = true
	SignalBus.game_over.emit()
