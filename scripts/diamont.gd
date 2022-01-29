extends Area2D

func _on_diamont_body_entered(body):
	$AudioCoin.play()
	GameControl.getDiamont()
	$AnimatedSprite.play("Destroy")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
