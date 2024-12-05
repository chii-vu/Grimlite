extends Node
# This is a 'global' or singleton in the game
#class_name GlobalSoundsManager


func sfx_hammer_hit() -> void:
	$Smash.play()
	
func sfx_explosion() -> void:
	$Explosion.play()

func sfx_player_hurt() -> void:
	$Hurt.play()

func sfx_background() -> void:
	$"Background Music".play()

func sfx_menu_music() -> void:
	$"Menu Music".play()

func sfx_menu_music_stop() -> void:
	$"Menu Music".stop()

func sfx_background_music_stop() -> void:
	$"Background Music".stop()

func sfx_eyeball() -> void:
	$"Eyeball Pop".play()

func sfx_cat() -> void:
	$"cat damage".play()
