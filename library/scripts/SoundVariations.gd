extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]

func play_sound():
	stream = streams.pick_random()
	play()

