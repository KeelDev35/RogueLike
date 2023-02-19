extends Node2D

onready var Breaking_case = get_node("Breaking_case")
onready var Animated_box = get_node("Animated_sprite")

onready var Medical_kit = preload("res://Scene/Levels/Object/MedicalKit.tscn")
onready var Grenade_loot = preload("res://Scene/Levels/Object/Grenade_loot.tscn")

export (int, "MedicalKit","Grenade") var drop_item

	
	
func hit(_value):
	var item_instance
	Breaking_case.play()
	Animated_box.play()
	

	yield(Animated_box,"animation_finished")
	match(drop_item):
		0 : item_instance = Medical_kit.instance()
		1 : item_instance = Grenade_loot.instance()

	
	item_instance.position = self.get_global_position()
	item_instance.rotation_degrees = rotation_degrees
	get_tree().get_root().add_child(item_instance)

	queue_free()
