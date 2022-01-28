extends StaticBody2D

var life = 2

func takeDamage(value):
	life = life - value
	if life <= 0 :
		$AnimatedSprite.play("Destroy")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
