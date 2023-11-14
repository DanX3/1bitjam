extends Area2D

const REFUGEES_COUNT = 4

var refugee_scene = preload("res://scenes/refugee.tscn")
var explostion_scene = preload("res://scenes/explosion.tscn")

func _on_body_entered(body):
	if body is Fireball:
		body.queue_free()
		Utils.add_here(self, explostion_scene)
		for i in range(REFUGEES_COUNT):
			$Spawner.spawn()
		queue_free()
