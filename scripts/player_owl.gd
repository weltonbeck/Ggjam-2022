extends "res://scripts/player_base.gd"

var pre_bullet = preload("res://scennes/effects/bullet.tscn")

var old_status = IDLE
var intangible = false
var intagibleTime = 1

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
	old_status = status
	
	if input_x > 0 :
		$AtackPosition.position.x = 15
	elif input_x < 0 :
		$AtackPosition.position.x = -15

func atack():
	if Input.is_action_just_pressed("ui_atack") && status != DEFENSE && status != MORPH && status != ATACK && status != HIT:
		status = ATACK
		var bullet = pre_bullet.instance()
		bullet.global_position = $AtackPosition.global_position
		
		var bullet_y = 0.5
		if is_on_floor() :
			 bullet_y = 0
		if $AnimatedSprite.flip_h == false :
			bullet.setDirection(Vector2(1,bullet_y))
		else :
			bullet.setDirection(Vector2(-1, bullet_y))
		get_parent().add_child(bullet)
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
		if old_status != MORPH :
			$AnimatedSprite.play("Morph")
			yield($AnimatedSprite, "animation_finished")
			GameControl.changePlayer(self, "cat",global_position)
	

func _on_hit_body_entered(body):
	if status != ATACK && intangible == false:
		intangible = true
		status = HIT
		$AnimatedSprite.play("Hit")
		yield($AnimatedSprite, "animation_finished")
		status = IDLE
		var t = get_tree().create_timer(intagibleTime)
		yield(t, "timeout")
		intangible = false
