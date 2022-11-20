extends Node2D

onready var Bullet_impact = get_node("Bullet_impact")
onready var Animated_sprite = get_node("Animated_sprite")


	
	
	
func _ready():
	Animated_sprite.play()
	Bullet_impact.play()
	pass
	
func _on_Bullet_impact_finished():
		queue_free()
 




