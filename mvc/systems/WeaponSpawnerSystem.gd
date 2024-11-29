extends Node
class_name WeaponSpawnerSystem

@export var hammer_prefab: PackedScene # prefab for 
@export var hammer_interval: float = 2.0 # interval in seconds between attacks
@export var hammer_offset: float = 100 # offset from player in (pixels?)
@export var hammer_lifetime: float = 0.6 # time in seconds for hammer's lifetime
@export var max_hammer: int = 5 # Max # of active hammer 
# dont think we really need a max # on bullet count 

@onready var hammer_group = Node.new()

var hammer_spawn_timer: float = 0.0
var player: Player # Ref to the player node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# hammer spawn
	hammer_spawn_timer += delta
	if hammer_spawn_timer >= hammer_interval:
		hammer_spawn_timer = 0
		_spawn_hammer()
	pass

func set_player(player_ref: Player) -> void:
	player = player_ref
	if !player:
		print("Error: Player reference is null in WeaponSpawnerSystem.set_player .")

################
#### HAMMER ####
################


func _init_hammer() -> void:
	get_parent().add_child(hammer_group)

func _spawn_hammer() -> void:
	## init + error checking
	if hammer_prefab == null:
		print("Error: hammer_prefab is not set. Check inspector settings.")
		return
	var new_hammer = hammer_prefab.instantiate() as Hammer
	if new_hammer == null:
		print("Error: Failed to instantiate Hammer from prefab")
		return
	
	# Add the hammer to the scene tree and to a group for management
	get_parent().add_child(new_hammer)
	new_hammer.add_to_group("bullets")
	new_hammer.add_to_group("hammers")
	
	# get hammer spawn position
	new_hammer.position = _get_hammer_spawn_position()
	
	## setup hammer timeout ##
	# code adapted from godotlearn's gd 3.1 tutorial on destroying nodes
	var timer = Timer.new()
	new_hammer.add_child(timer)
	
	 # kill new_hammer when its timer runs out
	timer.timeout.connect(Callable(new_hammer, "queue_free"))
	
	# not needed for hammer, but just in case
	if new_hammer.has_method("set_player"):
		new_hammer.set_player(player)
	
	# start hammer slam animation & life timer
	new_hammer.animation.slam_effect()
	timer.start(hammer_lifetime)
	return

# returns offsetted position for hammer projectile
func _get_hammer_spawn_position() -> Vector2:
	return player.position + \
		# normalized offset
		player.direction.normalized() * hammer_offset
