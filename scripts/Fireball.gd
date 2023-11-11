class_name Fireball extends CharacterBody2D

const SPEED := 200.0
var direction
var caravan

func init(dir: Vector2):
	direction = dir

func _ready():
	caravan = get_tree().get_first_node_in_group("caravan")

func _physics_process(delta):
	var collision = move_and_collide(delta * direction * SPEED)
	if collision != null:
		if collision.get_collider().name == caravan.name:
			queue_free()

func destroy():
	if $Particles1:
		$Particles1.emitting = false
		get_node("/root/UtilsInstance").destroy_after($Particles1, get_parent(), 1.1)
	if $Particles2:
		$Particles2.emitting = false
		get_node("/root/UtilsInstance").destroy_after($Particles2, get_parent(), 1.1)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
