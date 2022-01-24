extends KinematicBody2D

const MAX_SPEED = 200
const GRAVITY = 20
const GRAVITY_WALL_SLIDING = 0.05
const MAX_JUMP_FORCE = 420
const MIN_JUMP_FORCE = 100
var total_extra_jumps = 1
var current_jump = 0

var movement = Vector2(0, 0)
var input_x = 0

enum {
	IDLE, WALK, JUMP, FALL, HIT
}

var status = IDLE

func _physics_process(_delta):
	movement.y += GRAVITY
	walk()
	flip()
#	pass_through()
	if Input.is_action_just_pressed("ui_jump") :
		# pulo extra
		if (status == JUMP || status == FALL) && current_jump <= total_extra_jumps :
			jump(MAX_JUMP_FORCE)
		# pulo normal
		if status == IDLE || status == WALK :
			jump(MAX_JUMP_FORCE)

	if (status == JUMP && 
		movement.y < -MIN_JUMP_FORCE &&
		Input.is_action_just_released("ui_jump")):
		movement.y = -MIN_JUMP_FORCE
#
	movement = move_and_slide(movement, Vector2(0,-1))

	if is_on_floor() :
		movement.y = 0
		current_jump = 0
	
func flip() :
	if input_x > 0 :
		$AnimatedSprite.flip_h = false
	elif input_x < 0 :
		$AnimatedSprite.flip_h = true
		
func walk():
	input_x = 0
	# caso possa se mover
	if !(status == HIT):	
		input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input_x != 0:
		movement.x = MAX_SPEED * input_x
	elif input_x == 0:
		movement.x = lerp(movement.x,0, 0.2)

func jump(force):
	current_jump += 1
	movement.y = -force
	if status != HIT:
		status = JUMP
