extends Node

@export var UI_STREAM: PackedScene

func play_ui(stream: AudioStream):
	var stream_player = UI_STREAM.instantiate()
	add_child(stream_player)
	stream_player.stream = stream
	stream_player.play()
	await stream_player.finished
	stream_player.queue_free()
