extends Node
# This is a 'global' or singleton in the game
#class_name GlobalSoundsManager


func sfx_bullet() -> void:
	$Bullet.play()
	
func sfx_explosion() -> void:
	$Explosion.play()

func sfx_warp() -> void:
	$Explosion.play()
