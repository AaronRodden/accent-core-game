extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.timer_update.connect(update_timer_hud)
	SignalBus.endgame.connect(update_endgame_hud)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_timer_hud(current_timer_value: int):
	$TimerText.text = str(current_timer_value)

func update_endgame_hud(endgame_type: String):
	if endgame_type == "victory":
		$EndgameLabel.text = "YOU WIN!"
	elif endgame_type == "defeat":
		$EndgameLabel.text = "YOU LOSE!?!"
	$EndgameLabel.visible = true
