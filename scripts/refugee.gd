extends CharacterBody2D


const SPEED = 70.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	var caravan: Caravan = get_tree().get_first_node_in_group("caravan")
	var dir = (caravan.global_position - global_position).normalized()
	var collision = move_and_collide(delta * SPEED * dir)
	if collision == null:
		return
		
	if collision.get_collider().name == caravan.name:
		caravan.add_refugee()
		queue_free()
