extends Control

@onready var order: Order
@onready var grid = $OrderDisplay/H/V/GridContainer
@onready var timer_visual = $TextureProgressBar

func _ready():
	$OrderDisplay/PegsTexture.modulate = Color.from_hsv(randf_range(0, 1), 0.8, 1, 1)

func _process(_delta):
	timer_visual.value = $TextureProgressBar/Timer.time_left

func set_order(o: Order):
	for child in grid.get_children():
		child.queue_free()
	order = o
	grid.columns = order.width
	for y in order.height:
		for x in order.width:
			var rect = TextureRect.new()
			rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			rect.custom_minimum_size = Vector2(20, 20)
			rect.texture = order.grid[x][y].texture
			grid.add_child(rect)
	
	#Set max timer
	$TextureProgressBar/Timer.wait_time = order.countdown
	#$TextureProgressBar/Timer.start()
	timer_visual.max_value = order.countdown


func _on_timer_timeout():
	GameOverManager.game_over()
