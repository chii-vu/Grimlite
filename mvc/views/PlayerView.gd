extends Node2D
class_name PlayerView

@export var player: Player  # Reference to the Player node
@export var animated_sprite: AnimatedSprite2D  # Reference to the AnimatedSprite2D node

func _ready() -> void:
	# Ensure the player view is visible on start
	animated_sprite.visible = true

func _process(delta: float) -> void:
	# Only play the "Idle" animation as we aren’t handling other states for now
	#this is for the SHIP, not the actual Player
	animated_sprite.play("Idle")


#functions called in controller (Game.gd)
func move_left() -> void:
	$Sprite2D/AnimationPlayer.play("walk_left")

func move_right() -> void:
	$Sprite2D/AnimationPlayer.play("walk_right")

func no_input() -> void:
	$Sprite2D/AnimationPlayer.pause()
