extends "res://scripts/player_base.gd"

var pre_explosion = preload("res://scennes/effects/explosion.tscn")

var old_status = IDLE
var intangible = false
var intagibleTime = 1

func _ready():
	pass

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
	
	if status == DEFENSE :
		intangible = true
	elif old_status == DEFENSE && status != DEFENSE :
		intangible = false
	
	old_status = status
	
	if intangible == true :
		$HitArea.monitoring = false
	else :
		$HitArea.monitoring = true

func atack():
	if Input.is_action_just_pressed("ui_atack") && status != DEFENSE && status != MORPH && status != ATACK:
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
		if old_status != MORPH :
			$AnimatedSprite.play("Morph")
			yield($AnimatedSprite, "animation_finished")
			GameControl.changePlayer(self, "owl",global_position)


func _on_hit_body_entered(body):
	if status != ATACK && intangible == false:
		GameControl.takeDamage()
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
