extends Line2D

# Used to store the positions of the points
var queue : Array

# The length of the trail
@export var max_length : int

func _ready():
	set_process(false)
	get_parent().connect("start_trail", _on_start_trail)
	get_parent().connect("stop_trail", _on_stop_trail)

func _process(_delta):
	var pos = get_parent().position
	
	# FIFO type Array
	queue.push_front(pos)
	if queue.size() > max_length:
		queue.pop_back()
	clear_points()
	
	# Renders the points
	if queue:
		for point in queue:
			add_point(point)

func _on_start_trail():
	set_process(true)

func _on_stop_trail():
	set_process(false)
	queue.clear()
	clear_points()
