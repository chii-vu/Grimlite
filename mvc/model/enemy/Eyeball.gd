extends Area2D
class_name Eyeball

@export var speed: float = 100.0
var player: Player

@export var player_path: NodePath = "../../model/Player"

func _ready() -> void:
	# Attempt to find the player node using the relative path
	player = get_node(player_path) as Player

	if player:
		print("Player reference successfully set in EyeballView:", player)
	else:
		print("Failed to set player reference in EyeballView.")

@onready var view: EyeballView = $EyeballView  # Reference to the EyeballView node

func set_player(player_ref: Player) -> void:
	player = player_ref
	print("Player reference set in Eyeball:", player)

	# Pass the player reference to EyeballView if it exists
	if view:
		view.set_player(player)
		print("Passing player reference to EyeballView.")
	else:
		print("Error: EyeballView not found as a child of Eyeball.")

func _process(delta: float) -> void:
	if player:
		# Continuously move toward the player’s current position
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
		
		#var facing = (player.position-position)
		#if facing.y < 0 :
			#$EyeballView/Sprite2D/AnimationPlayer.play("move_right")
			#print(facing.y)
#
		#else:
			#$EyeballView/Sprite2D/AnimationPlayer.play("move_left")
			#print(facing.y)
