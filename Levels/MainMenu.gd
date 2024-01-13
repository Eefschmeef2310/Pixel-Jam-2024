extends Control

func _on_button_button_down():
	get_tree().change_scene_to_file("res://Levels/main_game.tscn")

func _on_button_3_button_down():
	get_tree().quit()

func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://Levels/Credits.tscn")
