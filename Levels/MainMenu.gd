extends Control

func _ready():
	$HBoxContainer/MarginContainer/VBoxContainer2/QuitButton.visible = OS.get_name() != "Web"
	OrderManager.timer_updating = false

func _on_start_button_button_down():
	ScoreManager.playtime = 0
	ScoreManager.score = 0
	get_tree().change_scene_to_file("res://Levels/level.tscn")

func _on_options_button_button_down():
	get_tree().change_scene_to_file("res://Levels/Options.tscn")

func _on_leaderboard_button_button_down():
	get_tree().change_scene_to_file("res://Levels/Leaderboard.tscn")

func _on_credits_button_button_down():
	get_tree().change_scene_to_file("res://Levels/Credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
