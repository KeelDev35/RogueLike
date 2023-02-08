##############
# TILE_SPAWN #
##############


### EXPANSION  ###

extends Node2D
class_name Astar_Spawn


### GLOBAL VARIABLES ####

onready var tilemap = get_node("TileMap")
#onready var timer = get_node("Timer")
var timer = Timer.new()

export var wait_start = 0.1
export var number = 30
export var min_wait_time = 0.1
export var max_wait_time = 0.1

export var spawner = preload("res://Scene/Zombie/Zombie.tscn")


### BUILT-IN ###

func _ready():
	randomize()
	add_child(timer)
	timer.wait_time = wait_start
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	_random_spawn()


### LOGICS ###	
func _random_spawn ():
	var used_cells = tilemap.get_used_cells()
	
	for i in number:
		timer.start()
		yield(timer,"timeout")
		var spawner_instance = spawner.instance()
		var rand_spawner_instance = used_cells[randi() % used_cells.size()]
		spawner_instance.position = Vector2 ((rand_spawner_instance.x *32) +16  , (rand_spawner_instance.y *32) +16)
		
		get_parent().add_child(spawner_instance)
		
func _on_timeout():
	timer.wait_time = rand_range(min_wait_time,max_wait_time) 
	pass
