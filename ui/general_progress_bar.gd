extends TextureProgressBar

const X_MIN_POSITION = 8
const X_MAX_POSITION = 7108

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress_ratio = self.value / 100
	var neuron_sprite_position = X_MAX_POSITION * progress_ratio
	neuron_sprite_position = clamp(neuron_sprite_position, X_MIN_POSITION, X_MAX_POSITION)
	$NeuronHeadSprite.position = Vector2(neuron_sprite_position, $NeuronHeadSprite.position.y)
