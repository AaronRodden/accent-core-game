extends CanvasLayer


func change_scene(target, type: String = 'add_child') -> void:
	if type == 'add_child':
		transition_add_child(target)
	elif type == "change_scene":
		transition_change_scene(target)

# TODO: We are still eating the loading time here!!
func transition_add_child(target) -> void:
	$AnimationPlayer.play('close_and_loading')
	await $AnimationPlayer.animation_finished
	Global.WORLD_NODE.add_child(target)
	get_node("/root/Main/World/StageSelect").queue_free()  # TODO: This is hardcoded to transition from StageSelect...
	$AnimationPlayer.play_backwards('close')
	
func transition_change_scene(target) -> void:
	$AnimationPlayer.play('close_and_loading')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('close')
