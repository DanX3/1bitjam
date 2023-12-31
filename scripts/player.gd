extends CharacterBody2D

class_name  Player

@export var speed := 200
@export var camera: Camera2D
@export var camera_distance := 200.0
@export var camera_reactivity := 1
@export var can_control = true


var fireballScene = preload("res://scenes/fireball.tscn")
var walk_dir: Vector2
var camera_point := Vector2.ZERO
const fireballDistance = 20.0
const fireballCost = 0.75
var life = 100.0
@onready var cooldown: Cooldown = $Cooldown
@onready var pivot = $Pivot
@onready var sprite = $AnimatedSprite2D
@onready var player = $AnimationPlayer
@onready var progress1 = $CanvasLayer/ProgressCharge
@onready var progress2 = $CanvasLayer/ProgressDischarge

func _ready():
	sprite.play("idle")
	progress1.value = 100.0 - life
	progress2.value = 100.0 - life
	get_node("/root/EventBusInstance").connect("camera_shake", func(): $Camera2D/CameraShake.shake())

func _input(event):
	if not can_control:
		return
	if Input.is_action_just_pressed("fire") and cooldown.is_ready():
		player.stop()
		player.play("fireball")

func spawn_fireball():
		take_damage(fireballCost)
		var fireball = fireballScene.instantiate()
		var fireballDir = (get_global_mouse_position() - global_position).normalized()
		fireball.init(fireballDir)
		get_parent().add_child(fireball)
		fireball.global_position = global_position + fireballDir * fireballDistance
		

#func _process(delta):
#	if camera != null:
#		camera_point = camera_distance * walk_dir
#		camera.position = lerp(camera.position, camera_point, delta * camera_reactivity)

func _physics_process(delta):
	if not can_control:
		return
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

func take_damage(damage: float):
	if damage > fireballCost:
		$Camera2D/CameraShake.shake()
	life -= damage
	progress1.value = 100.0 - life
	progress2.value = 100.0 - life
	if life <= 0.0:
		EventBusInstance.emit_signal("game_over")

const END_POS = Vector2(417, -3150)

func tween_to_end_pos():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", END_POS, 3)

func stop_music():
	$Maintheme.stop()
	$CanvasLayer.visible = false
