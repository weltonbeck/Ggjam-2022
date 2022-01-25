extends "res://scripts/player_base.gd"

func _ready():
	GRAVITY = 10

func _physics_process(_delta):
	startPhysics()
	getInput()
	flip()
	fly()
	if is_on_floor() :
		movement.x = movement.x / 2
	walk()
	finishPhysics()
	
	animation()


func animation():
	if status == IDLE:
		$AnimatedSprite.play("Stand")
	elif status == WALK:
		$AnimatedSprite.play("Walk")
	elif status == FLY:
		$AnimatedSprite.play("Fly")
	elif status == FALL:
		$AnimatedSprite.play("Fall")
