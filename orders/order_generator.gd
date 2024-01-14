extends Node

@onready var empty_rack_timer = $EmptyRackTimer
@onready var full_rack_timer = $FullRackTimer


func _process(_delta):
	if empty_rack_timer.is_stopped():
		if OrderManager.orders.is_empty():
			empty_rack_timer.start()
			full_rack_timer.stop()
			


func _on_empty_rack_timer_timeout():
	OrderManager.generate_2x2()
	full_rack_timer.start()


func _on_full_rack_timer_timeout():
	OrderManager.generate_2x2()
	full_rack_timer.start()
