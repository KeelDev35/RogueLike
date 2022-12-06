#################
# BULLET_IMPACT #
#################


### EXPANSION ###

extends Node2D


### GLOBAL VARIABLE ####

onready var Bullet_impact = get_node("Bullet_impact")
onready var Animated_sprite = get_node("Animated_sprite")


### BUILT-IN ###

func _ready():
	Animated_sprite.play()
	Bullet_impact.play()
	pass


### SIGNAL RESPONSES ###

func _on_Bullet_impact_finished():
		queue_free()
