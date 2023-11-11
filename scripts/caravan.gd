extends RigidBody2D

@export var start_position: Node2D
@export var velocity: int = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	position = start_position.position
	apply_central_force(Vector2.UP * velocity)
