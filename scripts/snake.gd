extends KinematicBody2D

export(int) var life = 2
var t = 0.0
var attacking
func _physics_process(delta):
	
	if get_node_or_null("SnakeAnimation") and get_node_or_null("SnakeCollision"):
		if attacking:
			t += delta * 0.5
			$SnakeAnimation.position = $SnakeAnimation.position.linear_interpolate(Vector2($SnakeAnimation.position.x, 0), t)
			$SnakeCollision.position = $SnakeCollision.position.linear_interpolate(Vector2($SnakeCollision.position.x, 0), t)
		else:
			t += delta * 0.019
			
			$SnakeAnimation.position = $SnakeAnimation.position.linear_interpolate(Vector2($SnakeAnimation.position.x, 180), t)
			$SnakeCollision.position = $SnakeCollision.position.linear_interpolate(Vector2($SnakeCollision.position.x, 180), t)
		

func _on_Area2D_body_exited(body):
	t = 0.0


func _on_Area2D_body_entered(body):
	$SnakeAnimation.play("attack")
	attacking = true
	t = 0.0
	yield(get_tree().create_timer(1), "timeout")
	if get_node_or_null("SnakeAnimation"):
		$SnakeAnimation.play("descendo")
	attacking = false
	t = 0.0
	
func takeDamage(value):
	life = life - value
	if life <= 0 :
		$SnakeAnimation.play("Destroy")
		yield($SnakeAnimation, "animation_finished")
		$SnakeAnimation.queue_free()
		$SnakeCollision.queue_free()
		$Area2D.queue_free()
	else :
		$SnakeAnimation.playing = false
		yield(get_tree().create_timer(0.5), "timeout")
		$SnakeAnimation.playing = true
