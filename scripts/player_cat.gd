extends "res://scripts/player_base.gd"

func _physics_process(_delta):
	startPhysics()
	getInput()
	flip()
	jumpPress()
	walk()
	finishPhysics()
	
	animation()


func animation():
	if status == IDLE:
		$AnimatedSprite.play("Stand")
	elif status == WALK:
		$AnimatedSprite.play("Walk")
	elif status == JUMP:
		$AnimatedSprite.play("Jump")
	elif status == FALL:
		$AnimatedSprite.play("Fall")
