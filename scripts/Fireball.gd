class_name Fireball extends CharacterBody2D

const SPEED := 500.0
const MAX_DURATION_MS = 250
var life_start
var direction
var caravan

func init(dir: Vector2):
	direction = dir

func _ready():
	life_start = Time.get_ticks_msec()
	caravan = get_tree().get_first_node_in_group("caravan")

func _physics_process(delta):
	if Time.get_ticks_msec() - life_start > MAX_DURATION_MS:
		queue_free()
		return
	var collision = move_and_collide(delta * direction * SPEED)
	if collision != null:
		if collision.get_collider().name == caravan.name:
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
#	queue_free()
