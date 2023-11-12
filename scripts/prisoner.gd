extends Area2D

var refugee_scene = preload("res://scenes/refugee.tscn")
var explostion_scene = preload("res://scenes/explosion.tscn")

func _on_body_entered(body):
	if body is Fireball:
		print("freed")
		body.queue_free()
		var refugee = refugee_scene.instantiate()
		get_parent().call_deferred("add_child", refugee)
		Utils.add_here(self, explostion_scene)
		refugee.position = position
		queue_free()
