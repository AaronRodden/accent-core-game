extends Node2D

@export var arrow = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#looping_movement()
	if Global.CURRENT_PLAYER == Global.player1:
		arrow = $ExperimentArrowBlue
		arrow.visible = true
		$ExperimentArrowGreen.visible = false
	elif Global.CURRENT_PLAYER == Global.player2:
		arrow = $ExperimentArrowGreen
		arrow.visible = true
		$ExperimentArrowBlue.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func looping_movement():
	var start_y: float = position.y
	var end_y: float = position.y - 30.0 
	
	# Create the upward movement tween
	var tween = create_tween().bind_node(self)
	tween.tween_property(self, "position:y", end_y, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	# Chain a downward movement tween
	tween.tween_property(self, "position:y", start_y, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	# Connect a signal to loop the movement once completed
	await tween.finished
	looping_movement() # Re-call the function to loop the animation
