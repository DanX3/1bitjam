extends RigidBody2D

const SPEED := 200.0

func init(dir: Vector2):
	apply_central_force(dir * SPEED)
