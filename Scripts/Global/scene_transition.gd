extends CanvasLayer

@onready var animation_player = $AnimationPlayer
var scene_changing = false

func change_scene(path: String):
	if scene_changing: return
	
	scene_changing = true
	animation_player.play("scene_trans")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	#get_tree().change_scene_to_packed(scene)
	animation_player.play_backwards("scene_trans")
	scene_changing = false
