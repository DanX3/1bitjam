extends CharacterBody2D

const WALK_SPEED = 30.0
const PLAYER_PROXIMITY = 20.0
const ATTACK_ANGLE = 0.8 * PI 

var player: Player
@onready var chart: StateChart = $StateChart
@onready var attackPivot: Node2D = $AttackPivot


func _on_walking_state_physics_processing(delta):
	velocity = WALK_SPEED * Vector2.DOWN
	move_and_slide()


func _on_visibility_body_entered(body):
	if body is Player:
		player = body
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
	move_and_slide()


func _on_attack_state_entered():
	attack()
	
func attack():
	var playerDir = player.global_position - global_position
	# go to player if too far away
	if playerDir.length() > PLAYER_PROXIMITY:
		chart.send_event("go_to_player")
		return
		
	var playerAngle = atan2(playerDir.y, playerDir.x)
	attackPivot.rotation = playerAngle - 0.5 * ATTACK_ANGLE
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(attackPivot, "rotation", attackPivot.rotation + ATTACK_ANGLE, 1.2)
	tween.connect("finished", attack)
