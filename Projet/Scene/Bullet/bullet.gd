 ##########
 # BULLET #
 ##########


### EXPANSION ###

extends RigidBody2D


### GLOBAL VARIABLE ###

onready var impact = preload("res://Scene/Bullet/bullet_impact.tscn")

var damage : int = 1


### BUILT-IN ###


func _ready():
	var __ = connect("body_entered", self, "_on_bullet_body_entered")


### SIGNAL RESPONSES ###

func _on_bullet_body_entered(body):
	if !body.is_in_group("Player"):
		var impact_instance = impact.instance()
		impact_instance.position = get_global_position()
		get_tree().get_root().add_child(impact_instance)
		
		if body.has_method("hit"):
			body.hit(damage)
		
		queue_free()
