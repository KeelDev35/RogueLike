extends Node2D
class_name Wave

onready var timer = get_node("Timer")

export var min_wait  : float
export var max_wait : float

var child_max
var child_index = 0

var time = 0.0
var time_max = 3

var pool_spawn : Array = []
var spawn_mob_finished : bool = false
var one_shoot : bool = false

signal wave_finish
signal wave_ready

func _ready():
	var __ = connect("wave_finish", get_parent(), "_on_wave_finished")
	__ = connect("wave_ready", get_parent(), "_start_wave")

func _process(_delta):
	time += _delta
	if time > time_max :
		_check_wave_finish()
		time = 0
	

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_A) and just_pressed:
#		print("get_children :",get_children())
#		print("child count :",get_child_count())
		print(get_tree().get_nodes_in_group("ENEMIES").size())

func _on_spawn_finished():
	child_index += 1 
	if child_index <= child_max :
		if get_child(child_index) == timer:
			child_index = child_index + 1
		get_child(child_index).start_spawn()
	else : emit_signal("wave_ready")
	
func _start_spawn_spawner():
	child_max = get_child_count() -1
	
	if child_index <= child_max:
		if get_child(child_index) == timer:
			child_index = child_index + 1

	get_child(child_index).start_spawn()

func _start_wave_spawn():
	pool_spawn.shuffle()
	for mob in pool_spawn:
		timer.start(rand_range(min_wait, max_wait)); yield(timer, "timeout")
		add_child(mob)
	
	spawn_mob_finished = true
	
	
func _check_wave_finish():

	var enemies_alive = get_tree().get_nodes_in_group("ENEMIES").size()
#	print ("_check_wave_finish()")
		
	if spawn_mob_finished and !one_shoot:
		print(enemies_alive)
		if enemies_alive == 0:
			one_shoot = true
			print("wave_finish")
			emit_signal("wave_finish")
	


