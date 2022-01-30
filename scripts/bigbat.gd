extends KinematicBody2D

var pre_fireball = preload("res://scennes/effects/enemy_fireball.tscn")

export(int) var life = 1
onready var ready = true
var flipped = false
var searching = false


func _physics_process(delta):
	if get_tree().get_nodes_in_group("Player"):
		var player = get_tree().get_nodes_in_group("Player")[0]
		$RayAttack.look_at(player.global_position)
		if global_position.direction_to(player.global_position).x > 0:
			scale.x = -1
		else:
			scale.x = 1
	if $RayAttack.is_colliding() and ready:
		ready = false
		var fireball = pre_fireball.instance()
		fireball.global_position = $AttackPosition.global_position
		var direction = fireball.global_position.direction_to($RayAttack.get_collider().global_position)
		fireball.setDirection(direction)
		get_parent().add_child(fireball)
		$AttackTimer.start(2)


func _on_AttackTimer_timeout():
	ready = true


func _on_VisibilityEnabler2D_screen_entered():
	$RayAttack.enabled = true
	searching = true


func _on_VisibilityEnabler2D_screen_exited():
	$RayAttack.enabled = false	
	searching = false

func takeDamage(value):
	life = life - value
	if life <= 0 :
		$Collision.disabled = true
		$AudioDeath.play()
		$AnimatedSprite.play("Destroy")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
