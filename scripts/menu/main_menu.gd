extends Control

func show_level_select():
	$TitleScreen.visible = false
	$LevelScreen.visible = true
	
func exit_game():
	get_tree().quit()
	
func start_level1():
	get_parent().load_new_scene("res://scenes/mountain_scene.tscn")
