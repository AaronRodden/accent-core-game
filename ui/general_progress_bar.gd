extends TextureProgressBar

const X_MIN_POSITION = 8
const X_MAX_POSITION = 7108

var neuron_head_sprite = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	if Global.CURRENT_PLAYER == Global.player1:
		$NeuronHeadSpriteBlue.visible = true
		$NeuronHeadSpriteGreen.visible = false
		neuron_head_sprite = $NeuronHeadSpriteBlue
	elif Global.CURRENT_PLAYER == Global.player2:
		$NeuronHeadSpriteGreen.visible = true
		$NeuronHeadSpriteBlue.visible = false
		neuron_head_sprite = $NeuronHeadSpriteGreen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress_ratio = self.value / 100
	var neuron_sprite_position = X_MAX_POSITION * progress_ratio
	neuron_sprite_position = clamp(neuron_sprite_position, X_MIN_POSITION, X_MAX_POSITION)
	neuron_head_sprite.position = Vector2(neuron_sprite_position, neuron_head_sprite.position.y)
