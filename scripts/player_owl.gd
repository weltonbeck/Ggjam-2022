extends "res://scripts/player_base.gd"

var dead = false

func _ready():
	GRAVITY = 10

func _physics_process(_delta):
	startPhysics()
	getInput()
	flip()
	fly()
	if is_on_floor() :
		movement.x = movement.x / 2
	atack()
	morph()
	walk()
	finishPhysics()
	
	animation()

func atack():
	if Input.is_action_pressed("ui_atack") && status != DEFENSE && status != MORPH && status != ATACK:
		status = ATACK
		$AnimatedSprite.play("Atack")
		yield($AnimatedSprite, "animation_finished")
		status = IDLE
		
	if status == ATACK :
		movement.x = 0
		movement.y = 0

func animation():
	if status == IDLE:
		$AnimatedSprite.play("Stand")
	elif status == WALK:
		$AnimatedSprite.play("Walk")
	elif status == FLY:
		$AnimatedSprite.play("Fly")
	elif status == FALL:
		$AnimatedSprite.play("Fall")
	elif status == MORPH:
		$AnimatedSprite.play("Morph")
		yield($AnimatedSprite, "animation_finished")
		if dead == false :
			GameControl.changePlayer("cat",global_position)
		dead = true
		queue_free()
		
