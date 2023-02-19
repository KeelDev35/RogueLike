extends Node2D

func _ready():
	var __ = $Area2D.connect("body_entered", self, "collect")

func collect(body):
	if body is Player and PlayerCarac.CurrentHP < PlayerCarac.MaxHP:
		body.heal(+2)
		queue_free()
		
