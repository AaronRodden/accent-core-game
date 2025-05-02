extends Camera2D

@export var playerA : CharacterBody2D

var player : CharacterBody2D
var lockedY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerA
	lockedY = self.global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Acceleration and Deceleration based on WPM?
	if player != null:
		self.global_position.y = lockedY
		self.global_position.x = player.global_position.x - 400
