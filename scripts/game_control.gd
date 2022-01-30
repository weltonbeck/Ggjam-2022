extends Node2D

var all_levels = [
	"res://scennes/levels/florest/level_1.tscn",
	"res://scennes/levels/cave/level_2.tscn",
	"res://scennes/levels/ocean/level_3.tscn"
]

var main_scenne = "res://scennes/levels/tela_selecao.tscn"

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

var last_hero = "cat"
var last_level = 1

func _ready():
	resetHud()
	hideHud()

func changeLevel(index):
	if all_levels.size() > index - 1:
		resetHud()
		last_level = index
		$HudCanvas/Fade/AnimationPlayer.play("FadeIn")
		yield($HudCanvas/Fade/AnimationPlayer,"animation_finished")
		showHud()
		get_tree().change_scene(all_levels[index - 1])
		yield(get_tree().create_timer(0.1), "timeout")
		var player_respawn = get_tree().get_nodes_in_group("PlayerRespawn")
		invokePlayer(last_hero, player_respawn[0].global_position)
		$HudCanvas/Fade/AnimationPlayer.play("FadeOut")
	else :
		changeScenneMain()
		
func changeScenneMain():
	$HudCanvas/Fade/AnimationPlayer.play("FadeIn")
	yield($HudCanvas/Fade/AnimationPlayer,"animation_finished")
	hideHud()
	get_tree().change_scene(main_scenne)
	$HudCanvas/Fade/AnimationPlayer.play("FadeOut")
	
func changeScenneCredits():
	$HudCanvas/Fade/AnimationPlayer.play("FadeIn")
	yield($HudCanvas/Fade/AnimationPlayer,"animation_finished")
	hideHud()
	get_tree().change_scene("res://scennes/levels/tela_credito.tscn")
	$HudCanvas/Fade/AnimationPlayer.play("FadeOut")	

func changeGameover():
	
	$HudCanvas/Fade/AnimationPlayer.play("FadeIn")
	yield($HudCanvas/Fade/AnimationPlayer,"animation_finished")
	resetHud()
	hideHud()
	get_tree().change_scene("res://scennes/levels/tela_gameover.tscn")
	$HudCanvas/Fade/AnimationPlayer.play("FadeOut")
	
func showHud() :
	$HudCanvas/Hud.visible = true

func hideHud() :
	$HudCanvas/Hud.visible = false
	
func resetHud() :
	cat_ego = 50
	owl_ego = 50
	life = 5
	total_diamonts = 0
	renderHearts()
	renderEgo()
	
func restoreLife() :
	life = max_life
#	if life > max_life :
#		life = max_life
	renderHearts()
	
func takeDamage() :
	if life > 0 :
		life -= 1
		renderHearts()
	if life <= 0 :
		changeGameover()
	
func renderHearts() :
	for i in range($HudCanvas/Hud/Hearts.get_child_count()):
		if i >= life :
			$HudCanvas/Hud/Hearts.get_child(i).set_texture(heart_off)
		else :
			$HudCanvas/Hud/Hearts.get_child(i).set_texture(heart_on)

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
	$HudCanvas/Hud/EgoBar/CatColorRect.rect_scale.x = cat_ego / max_ego
	$HudCanvas/Hud/EgoBar/OwlColorRect.rect_scale.x = owl_ego / max_ego
	
func invokePlayer(type, position):
	last_hero = type
	var player
	if type == "cat" :
		player = player_cat.instance()
	else :
		player = player_owl.instance()
	player.global_position = position
	var level = get_tree().get_nodes_in_group("Level")
	if level :
		level[0].add_child(player)


func getDiamont() :
	total_diamonts += 1
	$HudCanvas/Hud/Diamonts/RichTextLabel.text = str(total_diamonts).pad_zeros(3) + " x "
