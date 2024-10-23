extends Node2D
class_name PlayerView

@export var player : Player
@export var animated_sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# View logic here.  This function runs every frame.
	# 'player' is the model.  So in the view layer we
	# should READ ONLY the state / properties of the player
	# decide how to show or represent that state.
	

	# warp animation takes precidence	
	if player.WarpCounter > 0:
		animated_sprite.play("Warp")
	else:
		if player.TurningLeft:
			animated_sprite.play("RotateLeft")
		elif player.TurningRight:
			animated_sprite.play("RotateRight")
		else:
			animated_sprite.play("Idle")	

	# Hide if dead, show if alive example
	# ( this doesn't work right now but u get the idea )
	if player.Dead:
		$AnimatedSprite2D.visible = false
	else:
		$AnimatedSprite2D.visible = true
