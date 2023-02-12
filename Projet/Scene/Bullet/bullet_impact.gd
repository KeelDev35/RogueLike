#################
# BULLET_IMPACT #
#################


### EXPANSION ###

extends Node2D




### GLOBAL VARIABLE ####


onready var Animated_sprite = get_node("Animated_sprite")


### BUILT-IN ###

func _ready():
	Animated_sprite.play()
	pass


### LOGICS ###

func _choice_sound(value):
	if value == 1:
		$Soundbox/Wall_impact.play()
	
	if value == 2 :
		$Soundbox/Character_impact.play()
	
### SIGNAL RESPONSES ###

func _on_Bullet_impact_finished():
		queue_free()


func _on_Wall_impact_finished():
	queue_free()


func _on_Character_impact_finished():
	queue_free()
