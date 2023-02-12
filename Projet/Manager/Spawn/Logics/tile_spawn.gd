##############
# TILE_SPAWN #
##############


### EXPANSION  ###

extends Node2D
class_name Astar_Spawn


### GLOBAL VARIABLES ####

onready var tilemap = get_node("TileMap")

var timer_to_spawn = Timer.new()
var timer_to_begin = Timer.new()

export var wait_start = 0.1
export var number = 30
export var min_wait_time = 0.1
export var max_wait_time = 0.1
onready var sound_Begin_wave = $SoundBeginWave

export var spawner = preload("res://Scene/Zombie/Zombie.tscn")

signal spawn_finished
### BUILT-IN ###

func _ready():
	randomize()

	var __ = connect("spawn_finished", get_parent(),"_on_spawn_finished")
	add_child(timer_to_spawn)
	add_child(timer_to_begin)
	timer_to_begin.wait_time = wait_start
	timer_to_begin.one_shot = true
	timer_to_spawn.one_shot = true
	timer_to_spawn.connect("timeout", self, "_on_timeout")
	timer_to_begin.connect("timeout", self, "_on_timeout_begin")


### LOGICS ###	
func start_spawn():
	timer_to_begin.start()

func _random_spawn ():
	var used_cells = tilemap.get_used_cells()
	
	for i in number:
		timer_to_spawn.start()
		yield(timer_to_spawn,"timeout")
		var spawner_instance = spawner.instance()
		var rand_spawner_instance = used_cells[randi() % used_cells.size()]
		spawner_instance.position = Vector2 ((rand_spawner_instance.x *32) +16  , (rand_spawner_instance.y *32) +16)
		
		add_child(spawner_instance)
	
	emit_signal("spawn_finished")
	
func _on_timeout():
	timer_to_spawn.wait_time = rand_range(min_wait_time,max_wait_time) 
	pass

func _on_timeout_begin():
	sound_Begin_wave.play()
	yield(sound_Begin_wave,"finished")
	_random_spawn()
