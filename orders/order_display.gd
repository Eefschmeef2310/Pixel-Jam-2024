extends Control

@export var color : Gradient

@onready var order: Order
@onready var grid = $HBoxContainer/Panel/MarginContainer/GridContainer
@onready var timer_visual = $HBoxContainer/Panel/ProgressBar/TextureProgressBar
@onready var timer: Timer = $HBoxContainer/Panel/ProgressBar/TextureProgressBar/Timer

var target_position: Vector2

var tween: Tween

var max_time: float

func _ready():
	#$HBoxContainer/Panel/PegsTexture.modulate = Color.from_hsv(randf_range(0, 1), 0.8, 1, 1)
	position.y = 40
	modulate.a = 0
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", 0, 0.5)
	tween.parallel().tween_property(self, "modulate:a", 1, 0.5)
	

func _process(delta):
	position = lerp(position, target_position, 10*delta)
	
	timer_visual.value = timer.time_left
	timer_visual.modulate = color.sample(1.0 - timer_visual.value / timer_visual.max_value)
	
	#if timer_visual.value / timer_visual.max_value < 0.25:
		#timer_visual.modulate = Color.from_hsv(0, 0.8, 1)
	#elif timer_visual.value / timer_visual.max_value < 0.5:
		#timer_visual.modulate = Color.from_hsv(0.1, 0.8, 1)
		
	if !$Ticker.playing and timer_visual.value < 0.25 * timer_visual.max_value:
		$Ticker.play()
		$HBoxContainer/Panel/ProgressBar/TextureProgressBar/AnimationPlayer.play("TimerBounce")

func set_order(o: Order):
	for child in grid.get_children():
		child.queue_free()
	order = o
	grid.columns = order.width
	for y in order.height:
		for x in order.width:
			var rect = TextureRect.new()
			rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			rect.custom_minimum_size = Vector2(16, 16)
			if order.grid[x][y] != null:
				rect.texture = order.grid[x][y].texture
			grid.add_child(rect)
	
	#Set max timer
	timer.wait_time = order.countdown
	max_time = order.countdown
	timer.start()
	timer_visual.max_value = order.countdown

func complete_ticket():
	timer.stop()
	#ProgressBarBack.hide()
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
	

func add_time(time: float):
	var time_left = timer.time_left
	timer.stop()
	timer.wait_time = time_left + time
	if timer.wait_time > max_time:
		timer.wait_time = max_time
	timer.start()
	

func _on_timer_timeout():
	GameOverManager.game_over()
