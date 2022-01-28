extends Node2D

var player_cat = preload("res://scennes/players/player_cat.tscn")
var player_owl = preload("res://scennes/players/player_owl.tscn")

var total_diamonts = 0

func _ready():
	pass
	
func changePlayer(old_player, type, position):
	var player
	if type == "cat" :
		player = player_cat.instance()
	else :
		player = player_owl.instance()
	player.global_position = position
	get_parent().add_child(player)
	var camera = old_player.get_node("Camera2D")
	if camera :
		old_player.remove_child(camera)
		player.add_child(camera)
	old_player.queue_free()


func getDiamont() :
	total_diamonts += 1
	$HudCanvas/Diamonts/RichTextLabel.text = str(total_diamonts).pad_zeros(3) + " x "
