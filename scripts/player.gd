extends CharacterBody2D

class_name  Player

@export var speed := 200
@export var camera: Camera2D
@export var camera_distance := 200.0
@export var camera_reactivity := 1


var fireballScene = preload("res://scenes/fireball.tscn")
var walk_dir: Vector2
var camera_point := Vector2.ZERO
const fireballDistance = 20.0
@onready var cooldown: Cooldown = $Cooldown
@onready var pivot = $Pivot
@onready var sprite = $AnimatedSprite2D
@onready var player = $AnimationPlayer

func _ready():
	sprite.play("idle")

func _input(event):
	if Input.is_action_just_pressed("fire") and cooldown.is_ready():
		player.play("fireball")

func spawn_fireball():
		var fireball = fireballScene.instantiate()
		var fireballDir = (get_global_mouse_position() - global_position).normalized()
		fireball.init(fireballDir)
		add_child(fireball)
		fireball.global_position = global_position + fireballDir * fireballDistance
		

#func _process(delta):
#	if camera != null:
#		camera_point = camera_distance * walk_dir
#		camera.position = lerp(camera.position, camera_point, delta * camera_reactivity)

func _physics_process(delta):
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("move_up", "move_down")
	walk_dir = Vector2(x, y).normalized()
	velocity = speed * walk_dir
	move_and_slide()
	if abs(velocity.x) > 0.0:
		pivot.scale.x = sign(velocity.x)


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "attack":
		sprite.play("idle")
