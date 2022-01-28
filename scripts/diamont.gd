extends Area2D

func _on_diamont_body_entered(body):
	GameControl.getDiamont()
	queue_free()
