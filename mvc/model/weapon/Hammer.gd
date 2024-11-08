extends CharacterBody2D
class_name Hammer

# so we can easily access animation state from controller
@onready var animation: HammerView = $HammerView

func _ready() -> void:
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2.ZERO, true)
	if collision:
		if collision.get_collider().is_in_group("enemies"):
			collision.get_collider().call("queue_free")
	
	#if get_slide_collision_count():
		#queue_free()
	
