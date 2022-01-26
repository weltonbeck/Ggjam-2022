extends "res://scripts/player_base.gd"

var dead = false
var old_status = IDLE

func _physics_process(_delta):
	startPhysics()
	getInput()
	flip()
	jumpPress()
	defense()
	atack()
	morph()
	walk()
	finishPhysics()
	
	animation()
	old_status = status

func atack():
	if Input.is_action_pressed("ui_atack") && status != DEFENSE && status != MORPH && status != ATACK:
		status = ATACK
		$AnimatedSprite.play("Atack")
		yield($AnimatedSprite, "animation_finished")
		status = IDLE
		
	if status == ATACK :
		movement.x = movement.x / 2.5

func animation():
	if status == IDLE:
		$AnimatedSprite.play("Stand")
	elif status == WALK:
		$AnimatedSprite.play("Walk")
	elif status == JUMP:
		$AnimatedSprite.play("Jump")
	elif status == FALL:
		$AnimatedSprite.play("Fall")
	elif status == DEFENSE:
		if (old_status != DEFENSE):
			$AnimatedSprite.play("DefenseStart")
			yield($AnimatedSprite, "animation_finished")
			$AnimatedSprite.play("DefenseLoop")
	elif status == MORPH:
		$AnimatedSprite.play("Morph")
		yield($AnimatedSprite, "animation_finished")
		if dead == false :
			GameControl.changePlayer("owl",global_position)
		dead = true
		queue_free()
