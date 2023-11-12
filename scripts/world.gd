extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_node("/root/EventBusInstance").connect("castle_reached", _castle_reached)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/Label.text = str(Time.get_ticks_msec()*Engine.time_scale/1000.0)

func _castle_reached():
	for demon in get_tree().get_nodes_in_group("demon"):
		demon.queue_free()
	$EndGameSequence.play("end_game")

func show_victory():
	get_tree().change_scene_to_file("res://scenes/victory.tscn")
