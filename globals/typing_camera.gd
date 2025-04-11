extends Camera2D

@export var playerA : CharacterBody2D
@export var playerB : CharacterBody2D

var player : CharacterBody2D
var lockedY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals and Connections
	SignalBus.player_swap_keystroke.connect(_swap_player)

	pass # Replace with function body.
	#self.global_position = position.y
	player = playerA
	lockedY = self.global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Acceleration and Deceleration based on WPM?
	if player != null:
		self.global_position.y = lockedY
		self.global_position.x = player.global_position.x - 400
	
func _swap_player(event: InputEventKey, keystroke : String):
	if player == playerA:
		player = playerB
	elif player == playerB:
		player = playerA
