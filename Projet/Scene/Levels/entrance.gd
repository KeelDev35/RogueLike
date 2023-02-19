extends Area2D


func _ready():
	var __ = get_parent().get_node("SpawnManager").connect("room_finish", self, "_on_room_finished")


func _on_Entrance_body_entered(_body):
	if _body is Player:
		Global.from_level = get_parent().name
		var __ = get_tree().change_scene("res://Scene/Levels/" + self.name + ".tscn")

func _on_room_finished():
	$Sprite.visible = true
	$CollisionShape2D.disabled = false
	$AnimationPlayer.play("Flash")
