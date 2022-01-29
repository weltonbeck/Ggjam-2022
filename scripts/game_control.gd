extends Node2D

var player_cat = preload("res://scennes/players/player_cat.tscn")
var player_owl = preload("res://scennes/players/player_owl.tscn")

var heart_on = preload("res://sprites/hud/hud-heart-on.png")
var heart_off = preload("res://sprites/hud/hud-heart-off.png")

var total_diamonts = 0
var max_life = 5
var life = 5

var max_ego = 100.0
var cat_ego = 50
var owl_ego = 50
var ego_price = 5

func _ready():
	renderHearts()
	renderEgo()
	
func takeDamage() :
	if life > 0 :
		life -= 1
		renderHearts()
	if life <= 0 :
		print("Game over")
	
func renderHearts() :
	for i in range($HudCanvas/Hearts.get_child_count()):
		if i >= life :
			$HudCanvas/Hearts.get_child(i).set_texture(heart_off)
		else :
			$HudCanvas/Hearts.get_child(i).set_texture(heart_on)

func changeEgo(hero, price = 0):
	if price <= 0 :
		price = ego_price
	if hero == "cat" && owl_ego < max_ego:
		cat_ego -= price
		owl_ego += price
	elif  hero == "owl" && cat_ego < max_ego:
		cat_ego += price
		owl_ego -= price
		
	if owl_ego > max_ego :
		owl_ego = max_ego
	if cat_ego > max_ego :
		cat_ego = max_ego
	renderEgo()

func renderEgo() :
	$HudCanvas/EgoBar/CatColorRect.rect_scale.x = cat_ego / max_ego
	$HudCanvas/EgoBar/OwlColorRect.rect_scale.x = owl_ego / max_ego
	
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
