extends Area2D

export var speed = 150
export var direction = Vector2(1, 0.5)
var colliding = false

func _process(delta):
	if !colliding:
		translate(direction * speed * delta)

func setDirection (new_direction) :
	direction = new_direction

func _on_EnemyFireBall_body_entered(body):
	colliding = true
	$AnimatedSprite.play("explode")
	yield($AnimatedSprite, "animation_finished")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
