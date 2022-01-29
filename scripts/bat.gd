extends KinematicBody2D

enum MODE { VERTICAL, HORIZONTAL }

export(int) var life = 1
export(int) var fly_range = 300
export(MODE) var fly_mode = MODE.HORIZONTAL
export var fly_speed = 50

var normal_direction = true

onready var start_position = position
onready var motion: Vector2
var attacking = false
var attack_pos
var pre_attack_pos
onready var ready = true

func _physics_process(delta):
	if get_tree().get_nodes_in_group("Player"):
		$RayToFollow.look_at(get_tree().get_nodes_in_group("Player")[0].global_position)
	if $RayToFollow.is_colliding() and $RayToFollow.get_collider().is_in_group("Player") and !attacking:
		pre_attack_pos = global_position
		attack_pos = $RayToFollow.get_collider().global_position
		attacking = true

	if attacking:

		var direction = global_position.direction_to(attack_pos)
		motion = motion.linear_interpolate(direction * 1000, delta)
		var distance = global_position.distance_to(attack_pos)
		if distance < 10:
			$AnimatedSprite.play('Destroy')
			yield($AnimatedSprite,"animation_finished")
			motion = Vector2.ZERO
			attacking = false
			queue_free()

	else:

		if fly_mode == MODE.HORIZONTAL:
			if normal_direction:
				motion.x = fly_speed
				if position.x >= start_position.x + fly_range:
					normal_direction = false
			else:
				motion.x = fly_speed * -1
				if position.x <= start_position.x:
					normal_direction = true
		else:

			if normal_direction:
				motion = Vector2(0, fly_speed * -1)
				if position.y <= start_position.y - fly_range:
					normal_direction = false
			else:
				motion = Vector2(0, fly_speed)
				if position.y >= start_position.y:
					normal_direction = true

	motion = move_and_slide(motion)

func takeDamage(value):
	life = life - value
	if life <= 0 :
		$AnimatedSprite.play("Destroy")
		yield($AnimatedSprite, "animation_finished")
		queue_free()



