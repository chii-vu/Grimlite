# Eyeball.gd
extends CharacterBody2D
class_name Eyeball

@export var speed: float = 100.0
var player: Player

@onready var view: EyeballView = $EyeballView  # Ensure EyeballView is a child node

func _ready() -> void:
	pass  # Initialization code if needed

func _physics_process(delta: float) -> void:
	move_and_slide()
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().is_in_group("player"):
			player.emit_signal("hit")
			print("enemy collided with player")


func set_player(player_ref: Player) -> void:
	player = player_ref
	print("Player reference set in Eyeball:", player)
	
	if view:
		view.set_player(player)  # Pass the player reference to EyeballView
		print("Passing player reference to EyeballView.")
	else:
		print("Error: EyeballView not found as a child of Eyeball.")
