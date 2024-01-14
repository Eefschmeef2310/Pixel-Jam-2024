extends Label

func _ready():
	ScoreManager.connect("score_updated", _on_score_updated)
	
func _on_score_updated():
	text = "Score: " + str(ScoreManager.score)
