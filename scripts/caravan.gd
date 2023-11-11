extends CharacterBody2D

@export var start_position: Node2D
@export var speed: int = 300
@export var refugees: int = 0


func _ready():
	velocity = Vector2.UP * speed
	position = start_position.position


func _process(delta):
	move_and_slide()


func take_damage():
	refugees -= 1
	if refugees <= 0:
		EventBusInstance.emit_signal("game_over")
