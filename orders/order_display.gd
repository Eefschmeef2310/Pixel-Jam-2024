extends Control

@export var color : Gradient

@onready var order: Order
@onready var grid = $OrderDisplay/H/V/GridContainer
@onready var timer_visual = $TextureProgressBar

var tween: Tween

func _ready():
	$OrderDisplay/PegsTexture.modulate = Color.from_hsv(randf_range(0, 1), 0.8, 1, 1)
	position.y = 40
	modulate.a = 0
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", 0, 0.5)
	tween.parallel().tween_property(self, "modulate:a", 1, 0.5)
	

func _process(_delta):
	timer_visual.value = $TextureProgressBar/Timer.time_left
	
	timer_visual.modulate = color.sample(1.0 - timer_visual.value / timer_visual.max_value)
	
	#if timer_visual.value / timer_visual.max_value < 0.25:
		#timer_visual.modulate = Color.from_hsv(0, 0.8, 1)
	#elif timer_visual.value / timer_visual.max_value < 0.5:
		#timer_visual.modulate = Color.from_hsv(0.1, 0.8, 1)

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
	$TextureProgressBar/Timer.start()
	timer_visual.max_value = order.countdown

func complete_ticket():
	$TextureProgressBar/Timer.stop()
	#$ProgressBarBack.hide()
	timer_visual.hide()
	modulate = Color.GREEN
	
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", 40, 0.5)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)
	

func _on_timer_timeout():
	GameOverManager.game_over()
