extends Control

var options : PackedScene = preload("res://Levels/Options.tscn")
var leaderboard : PackedScene = preload("res://Levels/Leaderboard.tscn")
var credits : PackedScene = preload("res://Levels/Credits.tscn")

var particles = preload("res://grid/matched_particles.tscn")

func _ready():
	$VBoxContainer2/QuitButton.visible = OS.get_name() != "Web"
	OrderManager.timer_updating = false
	
	var p = particles.instantiate()
	p.position.x = -1000
	add_child(p)
	p.emitting = true

func _on_options_button_button_down():
	get_tree().root.add_child(options.instantiate())

func _on_leaderboard_button_button_down():
	get_tree().root.add_child(leaderboard.instantiate())

func _on_credits_button_button_down():
	get_tree().root.add_child(credits.instantiate())

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	ScoreManager.playtime = 0
	ScoreManager.score = 0
	OrderManager.reset()
	get_tree().change_scene_to_file("res://Levels/level.tscn")
