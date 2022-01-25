extends KinematicBody2D

export(int) var speed = 60
var movement = Vector2()
var direction = Vector2(-1,0)

func _physics_process(_delta):
	walk()
	flip()
	changeDirection()
		
func walk() :
	movement = direction * speed
	movement = move_and_slide(movement, Vector2(0,-1))
	
func changeDirection():
	if is_on_wall() :
		direction = direction * -1
	
func flip() :
	if movement.x < 0 :
		$AnimatedSprite.flip_h = false
	elif movement.x > 0 :
		$AnimatedSprite.flip_h = true
