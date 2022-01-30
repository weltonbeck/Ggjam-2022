extends "res://scripts/player_base.gd"

var pre_explosion = preload("res://scennes/effects/explosion.tscn")

var old_status = IDLE
var intangible = false
var intagibleTime = 1

var is_paused = false

func _ready():
	pass

func _physics_process(_delta):
	
	startPhysics()
	if !is_paused :
		getInput()
		flip()
		if (GameControl.cat_ego > 0) :
			jumpPress()
			defense()
			atack()
		else :
			movement.x = movement.x / 2
		morph()
	walk()
	finishPhysics()
	
	animation()
	
	if status == DEFENSE :
		GameControl.changeEgo("cat", (GameControl.ego_price / 2) * _delta)
		intangible = true
	elif old_status == DEFENSE && status != DEFENSE :
		intangible = false
		
	if old_status != JUMP && status == JUMP :
		$AudioJump.play()
		GameControl.changeEgo("cat", (GameControl.ego_price / 2))
	
	old_status = status
	
	if intangible == true :
		$HitArea.monitoring = false
	else :
		$HitArea.monitoring = true

func atack():
	if Input.is_action_just_pressed("ui_atack") && status != DEFENSE && status != MORPH && status != ATACK:
		$AudioAtack.play()
		GameControl.changeEgo("cat")
		status = ATACK
		if $AnimatedSprite.flip_h == true :
			$AtackArea/CollisionShape2D.position.x = -9
			$AtackArea/Position2D.position.x = -19
		else :
			$AtackArea/CollisionShape2D.position.x = 9
			$AtackArea/Position2D.position.x = 19
		$AtackArea.monitoring = true
		$AnimatedSprite.play("Atack")
		yield($AnimatedSprite, "animation_finished")
		$AtackArea.monitoring = false
		status = IDLE
		
	if status == ATACK :
		movement.x = movement.x / 2.5

func animation():
	if is_paused :
		$AnimatedSprite.play("Stand")
	elif status == IDLE:
		if (GameControl.cat_ego > 0) :
			$AnimatedSprite.play("Stand")
		else :
			$AnimatedSprite.play("Tired")
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
		if old_status != MORPH :
			$AudioMorph.play()
			$AnimatedSprite.play("Morph")
			yield($AnimatedSprite, "animation_finished")
			GameControl.invokePlayer("owl",global_position)
			queue_free()

func setPause(value):
	is_paused = value

func _on_hit_body_entered(body):
	if status != ATACK && intangible == false:
		$AudioHit.play()
		GameControl.takeDamage()
		if GameControl.life <= 0 :
			is_paused = true
		intangible = true
		status = HIT
		$AnimatedSprite.play("Hit")
		yield($AnimatedSprite, "animation_finished")
		status = IDLE
		var t = get_tree().create_timer(intagibleTime)
		yield(t, "timeout")
		intangible = false

func _on_atack_body_entered(body):
	if body.has_method("takeDamage"):
		var explosion = pre_explosion.instance()
		explosion.global_position = $AtackArea/Position2D.global_position
		get_parent().add_child(explosion)
		body.takeDamage(2)
