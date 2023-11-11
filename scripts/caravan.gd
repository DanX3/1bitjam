extends CharacterBody2D

@export var speed: int = 1
@export var refugees: int = 0

var closeDemonsCounter = 0

func _process(delta):
	if closeDemonsCounter > 0:
		return
	velocity = Vector2.UP * speed
	move_and_slide()


func take_damage():
	refugees -= 1
	if refugees <= 0:
		EventBusInstance.emit_signal("game_over")


func _on_enemy_detector_body_entered(body):
	closeDemonsCounter += 1
	$Counter.text = str(closeDemonsCounter)


func _on_enemy_detector_body_exited(body):
	closeDemonsCounter -= 1
	$Counter.text = str(closeDemonsCounter)
