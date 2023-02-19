extends Control


func _ready():
	var __ = $ColorRect/VBoxContainer/Btn_ExitToTitle.connect("pressed", self, "_on_ExitToTitle_pressed")


func _on_ExitToTitle_pressed():
	get_tree().change_scene("res://Scene/Levels/TitleScreen.tscn")


