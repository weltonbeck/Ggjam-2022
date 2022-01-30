extends KinematicBody2D

const MAX_SPEED = 170
var GRAVITY = 20
const MAX_JUMP_FORCE = 520
const MIN_JUMP_FORCE = 100
export(int) var total_extra_jumps = 0
var current_jump = 0

var movement = Vector2(0, 0)
var input_x = 0

enum {
	IDLE, WALK, JUMP, FALL, FLY, DEFENSE, ATACK, MORPH, HIT
}

var status = IDLE

func _physics_process(_delta):
	pass

func startPhysics():
	if status != MORPH :
		movement.y += GRAVITY

func finishPhysics():
	if is_on_floor() :
		movement.y = 0
		current_jump = 0

		if status != DEFENSE && status != ATACK && status != MORPH && status != HIT:
			if (input_x == 0 && (movement.x < 0.01 || movement.x > -0.01) ) :
				status = IDLE
			else :
				status = WALK
	elif movement.y > 0 && status != ATACK && status != MORPH && status != HIT:
		if status != FLY:
			status = FALL
		elif status == FLY && movement.y > 10 :
			status = FALL

func getInput():
	input_x = 0
	# caso possa se mover
	if !(status == HIT):
		input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input_x != 0:
		movement.x = MAX_SPEED * input_x
	elif input_x == 0:
		movement.x = lerp(movement.x,0, 0.2)

func flip() :
	if status != DEFENSE && status != MORPH && status != HIT:
		if input_x > 0 :
			$AnimatedSprite.flip_h = false
		elif input_x < 0 :
			$AnimatedSprite.flip_h = true

func walk():
	if status != DEFENSE && status != MORPH && status != HIT:
		movement = move_and_slide(movement, Vector2(0,-1))

func jumpPress():
	if Input.is_action_just_pressed("ui_jump") && status != DEFENSE && status != ATACK && status != MORPH && status != HIT:
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

func jump(force):
	current_jump += 1
	movement.y = -force
	if status != HIT:
		status = JUMP

func fly():
	if Input.is_action_pressed("ui_jump")  && status != ATACK && status != MORPH && status != HIT:
		if status != JUMP && (total_extra_jumps == 0  || current_jump > total_extra_jumps) :
			movement.y = -MIN_JUMP_FORCE
			status = FLY

func defense():
	if Input.is_action_pressed("ui_defense") :
		if is_on_floor() && status != ATACK && status != MORPH && status != HIT:
			status = DEFENSE

	if Input.is_action_just_released("ui_defense") && status == DEFENSE:
		status = IDLE
		movement.x = 0

func atack():
	pass

func morph():
	if Input.is_action_pressed("ui_morph") && status != ATACK && status != HIT:
		status = MORPH
