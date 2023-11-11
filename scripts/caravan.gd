class_name Caravan extends CharacterBody2D

@export var speed: int = 1
@export var refugees: int = 10

@onready var counterLabel = $CanvasLayer/HumansCounter
@onready var passengerSprite = $Passengers

var closeDemonsCounter = 0

func _ready():
	counterLabel.text = str(refugees)
	if refugees > 0:
		passengerSprite.visible = true

func _process(delta):
	if closeDemonsCounter > 0:
		return
	velocity = Vector2.UP * speed
	move_and_slide()


func take_damage():
	get_node("/root/UtilsInstance").frame_freeze(0.5, 0.5)
	
	refugees -= 1
	counterLabel.text = str(refugees)
	if refugees <= 0:
		passengerSprite.visible = false		
		EventBusInstance.emit_signal("game_over")

func add_refugee():
	refugees += 1
	counterLabel.text = str(refugees)
	passengerSprite.visible = true
	

func _on_enemy_detector_body_entered(body):
	closeDemonsCounter += 1


func _on_enemy_detector_body_exited(body):
	closeDemonsCounter -= 1


func _on_hurt_box_body_entered(body):
	take_damage()


func _on_hurt_box_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	take_damage()
