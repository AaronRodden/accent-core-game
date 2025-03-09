class_name IntrusiveWord
extends Sprite2D

@onready var text_label = $IntrusiveWordText

var target_word : String

var running_string : String = ""
var word_progress : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	text_label.text = self.target_word


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_word():
	var running_length = len(self.running_string)
	var target_sub_word = self.target_word.substr(0, running_length)
	if self.running_string == target_sub_word:
		self.word_progress = float(running_length) / float(len(target_word))
		material.set("shader_parameter/gradient_percentage", self.word_progress)
	else:
		material.set("shader_parameter/gradient_percentage", 0.0)

	if self.running_string == self.target_word:
		self.queue_free()
