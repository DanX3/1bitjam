class_name Caravan extends CharacterBody2D

@export var speed: int = 1
@export var refugees: int = 10

@onready var counterLabel = $CanvasLayer/HumansCounter

var closeDemonsCounter = 0

func _ready():
	counterLabel.text = str(refugees)

func _process(delta):
	if closeDemonsCounter > 0:
		return
	velocity = Vector2.UP * speed
	move_and_slide()


func take_damage():
	refugees -= 1
	counterLabel.text = str(refugees)
	if refugees <= 0:
		EventBusInstance.emit_signal("game_over")

func add_refugee():
	refugees += 1
	counterLabel.text = str(refugees)

func _on_enemy_detector_body_entered(body):
	closeDemonsCounter += 1
	$EnemyCounter.text = str(closeDemonsCounter)


func _on_enemy_detector_body_exited(body):
	closeDemonsCounter -= 1
	$EnemyCounter.text = str(closeDemonsCounter)
