extends Area2D

export var level_number = 1

func _on_level_end_body_entered(body):
	GameControl.changeLevel(level_number)
