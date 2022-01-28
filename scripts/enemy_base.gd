extends KinematicBody2D

export(int) var life = 1
export(int) var speed = 60

const GRAVITY = 20

var walk = true
var movement = Vector2(-1, 0)
var direction = -1

func _physics_process(_delta):
	walk()
	flip()
	changeDirection()
		
func walk() :
	if is_on_floor() :
		movement.y = 0
	movement.y += GRAVITY
		
	if walk :
		movement.x = direction * speed
	movement = move_and_slide(movement, Vector2(0,-1))
	
	
func changeDirection():
	if is_on_wall() :
		movement.x = 0
		direction = direction * -1
	
func flip() :
	if movement.x < 0 :
		$AnimatedSprite.flip_h = false
	elif movement.x > 0 :
		$AnimatedSprite.flip_h = true
	
	
func takeDamage(value):
	life = life - value
	if life <= 0 :
		$AnimatedSprite.play("Destroy")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
	else :
		walk = false
		var t = get_tree().create_timer(0.5)
		$AnimatedSprite.playing = false
		yield(t, "timeout")
		walk = true
		$AnimatedSprite.playing = true
