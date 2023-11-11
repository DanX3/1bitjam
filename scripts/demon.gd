extends CharacterBody2D

const WALK_SPEED = 40.0
const PLAYER_PROXIMITY = 20.0
const ATTACK_ANGLE = 1.2 * PI 
const PLAYER_DAMAGE = 5.0

var player: Player
@onready var chart: StateChart = $StateChart
@onready var attackPivot: Node2D = $AttackPivot
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attackShape: CollisionShape2D = $AttackPivot/Attack/CollisionShape2D
var attackingCaravan := false

func _on_walking_state_physics_processing(delta):
	var caravanPos = get_tree().get_first_node_in_group("caravan").global_position
	velocity = WALK_SPEED * (caravanPos - global_position).normalized()
	var collision = move_and_collide(delta * velocity)
	if collision != null:
		print("collided")
		print(collision.get_collider().name)
		if collision.get_collider().name == "Caravan":
			print("found caravan")
			chart.send_event("attack_caravan")


func _on_visibility_body_entered(body):
	if body is Player:
		player = body
		attackShape.set_deferred("disabled", true)
		chart.send_event("found_player")


func _on_go_to_player_state_physics_processing(delta):
	if player == null:
		velocity = Vector2.ZERO
		return
	
	var playerDist = player.global_position - global_position
	if playerDist.length() < PLAYER_PROXIMITY:
		chart.send_event("close_to_player")
		return
	var playerDir = playerDist.normalized()
	velocity = WALK_SPEED * playerDir
	var collision = move_and_collide(delta * velocity)
	if collision != null:
		print(collision.get_collider().name)
		if collision.get_collider().name == "Caravan":
			chart.send_event("attack_caravan")


func _on_attack_state_entered():
	attack()
	
func attack():
	var playerDir = player.global_position - global_position
	# go to player if too far away
	if playerDir.length() > PLAYER_PROXIMITY:
		attackShape.disabled = true
		chart.send_event("go_to_player")
		return
		
	var playerAngle = atan2(playerDir.y, playerDir.x)
	attackPivot.rotation = playerAngle - 0.5 * ATTACK_ANGLE
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(attackPivot, "rotation", attackPivot.rotation + ATTACK_ANGLE, 1.2)
	tween.connect("finished", attack)
	attackShape.disabled = false
	sprite.play("attack")


func _on_hurt_box_body_entered(body):
	if body is Fireball:
		body.queue_free()
		chart.send_event("die")

func _on_attack_caravan_state_entered():
	attackingCaravan = true
	attack_caravan()



func attack_caravan():
	if not attackingCaravan:
		return
	var caravanDir = get_tree().get_first_node_in_group("caravan").global_position - global_position
	var caravanAngle = atan2(caravanDir.y, caravanDir.x)
	attackPivot.rotation = caravanAngle - 0.5 * ATTACK_ANGLE
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(attackPivot, "rotation", attackPivot.rotation + ATTACK_ANGLE, 1.2)
	tween.connect("finished", attack_caravan)
	attackShape.disabled = false
	sprite.play("attack")


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "die":
		queue_free()


func _on_attack_body_entered(body):
	if body is Player:
		(body as Player).take_damage(PLAYER_DAMAGE)


func _on_walking_state_entered():
	sprite.play("idle")

func _on_go_to_player_state_entered():
	sprite.play("idle")
	attackShape.set_deferred("disabled", true)

func _on_attack_state_exited():
	attackShape.set_deferred("disabled", true)

func _on_attack_caravan_state_exited():
	attackShape.set_deferred("disabled", true)
	attackingCaravan = false


func _on_die_state_entered():
	sprite.play("die")


func _on_idle_visibility_body_entered(body):
	if body is Player:
		player = body
		chart.send_event("go_to_player")


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.start()


func _on_timer_timeout():
	player = get_tree().get_first_node_in_group("player")
	chart.send_event("go_to_player")
