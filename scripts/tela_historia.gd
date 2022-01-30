extends Node2D


func _ready():
	$AnimationPlayer.play("01")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("02")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("03")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("04")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("05")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("06")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("07")
	yield($AnimationPlayer, "animation_finished")
	GameControl.changeLevel(1)
