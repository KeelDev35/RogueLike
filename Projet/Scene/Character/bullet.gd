extends RigidBody2D

var impact = preload("res://Scene/Character/bullet_impact.tscn")

func _on_bullet_body_entered(body):
	if !body.is_in_group("Character"):
		var impact_instance = impact.instance()
		impact_instance.position = get_global_position()
		get_tree().get_root().add_child(impact_instance)
		
		queue_free()
