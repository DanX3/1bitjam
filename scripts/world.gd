extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Engine.time_scale = 10
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/Label.text = str(Time.get_ticks_msec()*Engine.time_scale/1000.0)
