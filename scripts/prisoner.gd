extends Area2D

var refugee_scene = preload("res://scenes/refugee.tscn")

func _on_body_entered(body):
	if body is Fireball:
		print("freed")
		body.queue_free()
		var refugee = refugee_scene.instantiate()
		get_parent().call_deferred("add_child", refugee)
		refugee.position = position
		queue_free()
