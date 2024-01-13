extends Node

func _ready():
	pass

func _on_startup_timer_timeout():
	OrderManager.generate_2x2()
