extends CanvasLayer

func change_scene(target, type: String = 'add_child') -> void:
	
	if Global.CURRENT_PLAYER == Global.player1:
		var texture = load('res://assets/neuron_head_blue.png')
		$Control/CenterContainer/NeuronHead.texture = texture
		$RichTextLabel.text = "[wave amp=50.0 freq=5.0 connected=1][b]Player 1's Turn[/b][/wave]"
	if Global.CURRENT_PLAYER == Global.player2:
		var texture = load('res://assets/neuron_head_green.png')
		$Control/CenterContainer/NeuronHead.texture = texture
		$RichTextLabel.text = "[wave amp=50.0 freq=5.0 connected=1][b]Player 2's Turn[/b][/wave]"
		
	if type == 'add_child':
		transition_add_child(target)
	elif type == "change_scene":
		transition_change_scene(target)

# TODO: We are still eating the loading time here!!
func transition_add_child(target) -> void:
	$AnimationPlayer.play('close_and_loading')
	await $AnimationPlayer.animation_finished
	Global.WORLD_NODE.add_child(target)  # TODO: This throws an error when ThoughtPathRacing alredy has a parent World
	get_node("/root/Main/World/StageSelect").queue_free()  # TODO: This is hardcoded to transition from StageSelect...
	$AnimationPlayer.play_backwards('close')
	
func transition_change_scene(target) -> void:
	$AnimationPlayer.play('close_and_loading')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('close')
