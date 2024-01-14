extends CanvasLayer

func _ready():
	get_tree().paused = true
	AirtableManager.GameComplete(ScoreManager.score, ScoreManager.playtime)
	
	$MarginContainer/VBoxContainer/Label4.text = "Orders Completed: " + str(ScoreManager.score)

func _on_menu_button_button_down():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")
