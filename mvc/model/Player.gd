extends CharacterBody2D
class_name Player

@export var speed: float = 200.0
@export var health: float = 1.0  # Player health, adjust as needed
var dead: bool = false  # Player status


func _ready() -> void:
	print("Player is ready.")
