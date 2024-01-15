extends Sprite2D

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		queue_free()
