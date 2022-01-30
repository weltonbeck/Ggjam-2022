tool
extends Node2D

const SPIKE = preload("res://scennes/enemies/spike.tscn")
export(int) var size = 1 setget set_size

func _ready():
	create_spikes()

func _draw():
	if is_inside_tree() && Engine.editor_hint:
		create_spikes()

func set_size(value):
	if value >= 1:
		size = value
		update()

func create_spikes():
	# remove todos
	for spike in get_children():
		spike.queue_free()

	# cria denovo
	var i = 0
	while i < size:
		var new_spike = SPIKE.instance()
		new_spike.position.x += 16 * i
		add_child(new_spike)
		i += 1
