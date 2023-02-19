extends Node2D


func _ready():
	var __ = $Area2D.connect("body_entered", self, "collect")

func collect(body):
	if body is Player and PlayerCarac.CurrentGrenade < PlayerCarac.MaxGrenade:
		body.collect(0,+1)
		queue_free()
