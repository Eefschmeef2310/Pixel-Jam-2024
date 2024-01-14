extends Control

func _on_button_button_down():
	ScoreManager.playtime = 0
	ScoreManager.score = 0
	get_tree().change_scene_to_file("res://Levels/level.tscn")

func _on_button_3_button_down():
	get_tree().quit()

func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://Levels/Credits.tscn")

func _on_leaderboard_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Leaderboard.tscn")
