extends Node
class_name WeaponSpawnerSystem

@export var hammer_prefab: PackedScene # prefab for 
@export var hammer_interval: float = 1.0 # interval in seconds between attacks
@export var hammer_offset: float = 10 #offset from player in (pixels?)
@export var max_hammer: int = 5 # Max # of active hammer 
# dont think we really need a max # on bullet count 

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
	if player:
		print("Player reference set in WeaponSpawnerSystem: ", player)
	else:
		print("Error: Player reference is null in WeaponSpawnerSystem.set_player .")

################
#### HAMMER ####
################

func _spawn_hammer() -> void:
	if hammer_prefab == null:
		print("Error: hammer_prefab is not set. Check inspector settings.")
		return
	var new_hammer = hammer_prefab.instantiate() as Hammer
	if new_hammer == null:
		print("Error: Failed to instantiate Hammer from prefab")
		return
	
	new_hammer.position = _get_hammer_spawn_position()
	pass

# returns offsetted position for hammer projectile
func _get_hammer_spawn_position() -> Vector2:
	return player.position + \
		# normalized offset
		player.direction.normalized() * hammer_offset
