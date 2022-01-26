extends Node2D

var player_cat = preload("res://scennes/players/player_cat.tscn")
var player_owl = preload("res://scennes/players/player_owl.tscn")

func _ready():
	pass
	
func changePlayer(type, position):
	var player
	if type == "cat" :
		player = player_cat.instance()
	else :
		player = player_owl.instance()
	player.global_position = position
	get_parent().add_child(player)
