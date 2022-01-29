extends Area2D

func _on_fruit_body_entered(body):
	$AudioFruit.play()
	GameControl.restoreLife()
	$AnimatedSprite.play("Destroy")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
