extends Node2D

export var min_wait  : float
export var max_wait : float

onready var timer = $Timer
var child_max
var child_index = 0

var tiler

signal wave_finish
signal room_finish

func _ready():
	randomize()
	child_max = get_child_count() -1
	
	if get_child(child_index) == timer:
		child_index = child_index + 1
	get_child(child_index)._start_spawn_spawner()
	
	pass

func _start_wave():
	
#	var __ = yield(get_tree().create_timer(rand_range(min_wait, max_wait)), "timeout")
	timer.start(rand_range(min_wait, max_wait)); yield(timer, "timeout")
	
	if child_index <= child_max:
		if get_child(child_index) == timer:
			child_index = child_index + 1
		
	get_child(child_index)._start_wave_spawn()
	
func _on_wave_finished():
	emit_signal("wave_finish")
	child_index += 1 
	if child_index <= child_max :
		if get_child(child_index) == timer:
			child_index = child_index + 1
		get_child(child_index)._start_spawn_spawner()
		
	else : emit_signal("room_finish")
