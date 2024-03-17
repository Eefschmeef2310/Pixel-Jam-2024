extends Node

signal score_updated()

var score: int = 0:
	set(value):
		score = value
		score_updated.emit()
var playtime: float

func _process(delta):
	playtime += delta
