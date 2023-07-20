extends Node

func play_ui(stream: AudioStream):
	var stream_player = AudioStreamPlayer.new()
	stream_player.bus = 'UI'
	stream_player.stream = stream
	add_child(stream_player)
	stream_player.play()
	await stream_player.finished
	stream_player.queue_free()
