extends Control

var current_health = 5

func get_bbcode_color_tag(color : Color):
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag():
	return "[/color]"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Signals and Connections
	SignalBus.player_hit.connect(_reduce_health)
	
	if Global.CURRENT_PLAYER == Global.player1:
		$PlayerInfo/RichTextLabel.text = get_bbcode_color_tag(Color("#0082b9")) + "PLAYER 1 TURN" + get_bbcode_end_color_tag()
	elif Global.CURRENT_PLAYER == Global.player2:
		$PlayerInfo/RichTextLabel.text = get_bbcode_color_tag(Color("#3eb155")) + "PLAYER 2 TURN" + get_bbcode_end_color_tag()

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
	$Word_Info/Keystrokes.text = str(KeyboardInterface.total_keystrokes)


func victory():
	$GameEnd/GameEndText.text = "Success!!"
	$GameEnd.visible = true
	
func defeat():
	$GameEnd/GameEndText.text = "Game Over"
	$GameEnd.visible = true
	SignalBus.game_over.emit()
