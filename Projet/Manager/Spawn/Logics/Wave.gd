extends Node2D
class_name Wave

var child_max
var child_index = 0

func _ready():
	child_max = get_child_count()
	print(child_max)
	
	if child_index < child_max:
		get_child(child_index).start_spawn()

func _on_spawn_finished():
	child_index += 1 
	if child_index <= child_max :
		get_child(child_index).start_spawn()
	
	else :  pass
