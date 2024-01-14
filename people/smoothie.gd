extends Node2D

var tween: Tween

func _ready():
	enter()

func enter():
	global_position.x = 0
	position.y = 143
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 1, 1)
	
func exit():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position:y", 290, 1)
	tween.tween_callback(queue_free)

func set_liquid_color(c: Color):
	$Liquid.self_modulate = c
