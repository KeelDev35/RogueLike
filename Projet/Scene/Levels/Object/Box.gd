extends Node2D

onready var Breaking_case = get_node("Breaking_case")
onready var Animated_box = get_node("Animated_sprite")

func _ready():
	Breaking_case.play()
	Animated_box.play()
	
