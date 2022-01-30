extends Area2D

var pre_explosion = preload("res://scennes/effects/explosion.tscn")

var speed = 150
var direction = Vector2(1, 0.25)

func _process(delta):
	translate(direction * speed * delta)

func setDirection (new_direction) :
	direction = new_direction

func _on_bullet_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(1)
	var explosion = pre_explosion.instance()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
