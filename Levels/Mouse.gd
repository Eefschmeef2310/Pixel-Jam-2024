extends Sprite2D

signal tutorialComplete()

var first_complete: bool = false

func _ready():
	if AirtableManager.saveRes.gamesPlayed > 0:
		tutorialComplete.emit()
		ScoreManager.playtime = 0
		queue_free()

func _process(_delta):
	if Input.is_action_just_released("click"):
		if !first_complete:
			first_complete = true
			$AnimationPlayer.play("MouseTutorial2")
		else:
			tutorialComplete.emit()
			ScoreManager.playtime = 0
			queue_free()
