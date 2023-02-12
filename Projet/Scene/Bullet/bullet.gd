 ##########
 # BULLET #
 ##########


### EXPANSION ###

extends RigidBody2D


### ENUMERATION ###

enum STATE{
	IDLE,
	IMPACT,
}


### GLOBAL VARIABLE ###
onready var  impact = preload("res://Scene/Bullet/bullet_impact.tscn")
var damage : int = 1


### BUILT-IN ###


func _ready():
	
	var __ = connect("body_entered", self, "_on_bullet_body_entered")


### SIGNAL RESPONSES ###

func _on_bullet_body_entered(body):
#	if !body.is_in_group("Player"):
		var impact_instance = impact.instance()
		if body.get_collision_layer() == 2 or 5 :
			impact_instance._choice_sound(2)

#
		if body.get_collision_layer() == 1 :
			impact_instance._choice_sound(1)
			
			
		impact_instance.position = get_global_position()
		get_tree().get_root().add_child(impact_instance)
		
		if body.has_method("hit"):
			body.hit(damage)
		
#			
#			
			
		


		queue_free()
		

	
#func _impact():
#	$AnimatedSprite.play("Impact")
#	$CollisionShape2D.disabled = true
#	self.linear_velocity = Vector2.ZERO
#	self.angular_velocity = 0
