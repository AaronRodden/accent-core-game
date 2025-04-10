extends CanvasLayer


func change_scene(target: Node, type: String = 'close') -> void:
	if type == 'close':
		transition_close(target)
	#else:
		# put another transition type here

# TODO: We are still eating the loading time here!!
func transition_close(target) -> void:
	$AnimationPlayer.play('close_and_loading')
	await $AnimationPlayer.animation_finished
	Global.WORLD_NODE.add_child(target)
	get_node("/root/Main/World/StageSelect").queue_free()
	$AnimationPlayer.play_backwards('close')
