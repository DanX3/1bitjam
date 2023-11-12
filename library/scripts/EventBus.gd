class_name Events extends Node

var saved_refugees := 0

func _ready():
	add_user_signal("game_over")
	add_user_signal("castle_reached")
	add_user_signal("camera_shake")
	# add user signals here

#add_user_signal("hurt", [
#	{ "name": "damage", "type": TYPE_INT },
#	{ "name": "source", "type": TYPE_OBJECT }
#])
