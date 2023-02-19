##############
# TILE_SPAWN #
##############


### EXPANSION  ###

extends Node2D
class_name Spawner

enum MOB_TYPE{
	ZOMBIE,
	SERGENT,
	SPIRIT,
	HOUND,
	}
export (MOB_TYPE) var mob_index
### GLOBAL VARIABLES ####

onready var tilemap = self
var mob 
#var timer_to_spawn = Timer.new()
#var timer_to_begin = Timer.new()

#export var wait_start = 0
export var number = 1
#export var min_wait_time = 0
#export var max_wait_time = 0


signal spawn_finished
### BUILT-IN ###

func _ready():
#	randomize()
	self.visible = false
	var __ = connect("spawn_finished", get_parent(),"_on_spawn_finished")
#	add_child(timer_to_spawn)
#	add_child(timer_to_begin)
#	timer_to_begin.wait_time = wait_start
#	timer_to_begin.one_shot = true
#	timer_to_spawn.one_shot = true
#	timer_to_spawn.connect("timeout", self, "_on_timeout")
#	timer_to_begin.connect("timeout", self, "_on_timeout_begin")
	_select_mob()
	


### LOGICS ###	
func _select_mob():
	match(mob_index):
		MOB_TYPE.ZOMBIE		: mob = preload("res://Scene/Zombie/Zombie.tscn")
		MOB_TYPE.SERGENT	: mob = preload("res://Scene/Sergent/Sergent.tscn")
		MOB_TYPE.SPIRIT		: mob = preload("res://Scene/Spirit/Spirit.tscn")
		MOB_TYPE.HOUND		: mob = preload("res://Scene/Hound/Hound.tscn")
		


func start_spawn():
	_random_spawn()

func _random_spawn ():
	var used_cells = tilemap.get_used_cells()
	
	for i in number:
#		timer_to_spawn.start()
#		yield(timer_to_spawn,"timeout")
		var mob_instance = mob.instance()
		mob_instance.set_name(self.name + str(i))
		var rand_mob_instance = used_cells[randi() % used_cells.size()]
		
		mob_instance.position = Vector2 ((rand_mob_instance.x *32) +16  , (rand_mob_instance.y *32) +16)
		
		get_parent().pool_spawn.append(mob_instance)
#		add_child(mob_instance)
	

	emit_signal("spawn_finished")
	
	
#func _on_timeout():
#	timer_to_spawn.wait_time = rand_range(min_wait_time,max_wait_time) 
#	pass
#
#func _on_timeout_begin():
##	sound_Begin_wave.play()
##	yield(sound_Begin_wave,"finished")
#	_random_spawn()
#	pass
