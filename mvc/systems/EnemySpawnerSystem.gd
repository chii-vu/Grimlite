extends Node
class_name EnemySpawnerSystem

@export var EyeballPrefab : PackedScene
@onready var RandomNumber : RandomNumberGenerator = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func tick(delta: float, target_container:Node, game_controller:Game) -> void:
	var asteroid_count = target_container.get_child_count()
	if asteroid_count < 10:
		spawn_asteroid(target_container)
		pass
	pass




func spawn_asteroid(target_container:Node) -> void:
	var new_asteroid = EyeballPrefab.instantiate() as Eyeball
	
	# Randomize size by changing scale
	# Can't scale rigidbody2d directly, instead sclae CollisionShape2D
	new_asteroid.get_node("CollisionShape2D").scale = Vector2(RandomNumber.randf_range(0.5, 1.5), RandomNumber.randf_range(0.5, 1.5))
	

	# Add to scene tree
	target_container.add_child(new_asteroid)
	
	# Set position outside camera view using random number generator
	var screen_bounds : Vector2  = target_container.get_viewport_rect().size / 2.0
	var new_pos = Vector2(0,0)
	# Spawn asteroid along top or bottom of screen
	if RandomNumber.randi_range(0,1) == 0:
		# Randomize X position
		new_pos.x = RandomNumber.randf_range(-screen_bounds.x, screen_bounds.x)
		if (RandomNumber.randi_range(0,1) == 0):
			# Spawn at top of screen
			new_pos.y = screen_bounds.y
		else:
			# Bottom of screen
			new_pos.y = -screen_bounds.y
	else:
		# Spawn on left or right side of screen
		# Randomize Y position
		new_pos.y = RandomNumber.randf_range(-screen_bounds.y, screen_bounds.y)
		if (RandomNumber.randi_range(0,1) == 0):
			# Spawn at right of screen
			new_pos.x = screen_bounds.x
		else:
			# Left of screen
			new_pos.x = -screen_bounds.x
	new_asteroid.position = new_pos

	# Set velocity to move towards center of screen
	# Start with current position at edge of screen, add a randomized offset to vary direction a bit
	var offset = 300
	var new_velocity = Vector2(RandomNumber.randf_range(-offset, offset), RandomNumber.randf_range(-offset, offset)) + new_asteroid.position
	# NORMALIZE this vector2 FROM origin (0,0) TOWARDS randomized current position
	new_velocity = new_velocity.normalized()
	# Reverse direction so it goes towards CENTER/origin (0,0)
	new_velocity = -new_velocity
	# Multiply to give it some speed
	new_velocity *= RandomNumber.randf_range(50, 150)
	new_asteroid.linear_velocity = new_velocity
	
	# Random rotational velocity - how fast they spin
	new_asteroid.angular_velocity = RandomNumber.randf_range(-7, 7)
	pass
