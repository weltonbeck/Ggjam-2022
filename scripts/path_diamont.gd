tool
extends Path2D

const COLLECTED = preload("res://scennes/others/diamont.tscn")

export var distance = 50 setget set_distance

func _ready():
	populate()
	
func set_distance(value):
	distance = value
	update()
	
func _draw():
	if is_inside_tree() && Engine.editor_hint:
		populate()
	
func populate():
	# remove todos
	for collected in get_children():
		collected.queue_free()
		
	var curve = get_curve()
	var length = curve.get_baked_length()
	var i = 0
	while i < length:
		var position = curve.interpolate_baked(i)
		i += distance
		var new_collected = COLLECTED.instance()
		new_collected.position = position
		add_child(new_collected)
