extends Area2D

export var level_number = 1

func _on_level_end_body_entered(body):
	$AudioEnd.play()
	if body.has_method("setPause"):
		body.setPause(true)
	yield($AudioEnd, "finished")
	GameControl.changeLevel(level_number)
