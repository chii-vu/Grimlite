extends RigidBody2D
class_name Player

var TurningLeft : bool = false
var TurningRight : bool = false
var WarpCounter : float = 0
var RespawnCounter : float = 0
var Health : float = 1.0
var Dead : bool = false

var TargetWarpLocation : Vector2 = Vector2.ZERO


func _integrate_forces(state):
	if not TargetWarpLocation.is_equal_approx(Vector2.ZERO):
		position = TargetWarpLocation
		TargetWarpLocation = Vector2.ZERO
	
