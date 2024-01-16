extends Node

@onready var empty_rack_timer = $EmptyRackTimer
@onready var full_rack_timer = $FullRackTimer
@onready var hard_order_timer = $HardOrderTimer

@onready var mouse = $"../Mouse"

var full_rack_wait_time_init = 0

var should_spawn_hard_order: bool = false

var generation_types_easy: Array[String] = [
	"generate_2x2"
]
var generation_types_medium: Array[String] = [
	"generate_3x2",
	"generate_2x3",
	"generate_3x3_cross"
]
var generation_types_hard: Array[String] = [
	"generate_3x3",
	"generate_4x2",
	"generate_2x4"
]

func _ready():
	pass

func _process(_delta):
	if empty_rack_timer.is_stopped() and !mouse:
		if OrderManager.orders.is_empty():
			empty_rack_timer.start()


func _on_empty_rack_timer_timeout():
	generate_order()

func _on_full_rack_timer_timeout():
	generate_order()
	full_rack_timer.wait_time = full_rack_wait_time_init * OrderManager.order_arrival_curve.sample(OrderManager.get_difficulty_curve_x())
	
	print(full_rack_timer.wait_time)
	full_rack_timer.start()


func _on_hard_order_timer_timeout():
	should_spawn_hard_order = true


func generate_order():
	if should_spawn_hard_order:
		# check if a hard order exists already
		for order in OrderManager.orders:
			if order != null and (order.type in generation_types_medium or order.type in generation_types_hard):
				OrderManager.call(generation_types_easy.pick_random())
				return
		
		# spawn a hard order
		if OrderManager.difficulty_timer >= OrderManager.hard_order_threshold:
			OrderManager.call(generation_types_hard.pick_random())
		else:
			OrderManager.call(generation_types_medium.pick_random())
		should_spawn_hard_order = false
		hard_order_timer.start()
	else:
		OrderManager.call(generation_types_easy.pick_random())


func _on_mouse_tutorial_complete():
	OrderManager.timer_updating = true
	OrderManager.reset()
	full_rack_wait_time_init = full_rack_timer.wait_time
