extends AnimationPlayer

func _ready():
	play(autoplay)
	seek(randf_range(0, current_animation_length))
