extends Node2D
class_name PlayerView

@export var player: Player  # Reference to the Player node
@export var animated_sprite: AnimatedSprite2D  # Reference to the AnimatedSprite2D node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


#functions called in controller (Game.gd)
func move_left() -> void:
	$Sprite2D/AnimationPlayer.play("walk_left")
	

func move_right() -> void:
	$Sprite2D/AnimationPlayer.play("walk_right")

func no_input() -> void:
	$Sprite2D/AnimationPlayer.pause()

func continue_moving() -> void:
	$Sprite2D/AnimationPlayer.play()

func damage_left() -> void:
	$Sprite2D/AnimationPlayer.play("damage_left")
	
func damage_right() -> void:
	$Sprite2D/AnimationPlayer.play("damage_right")
