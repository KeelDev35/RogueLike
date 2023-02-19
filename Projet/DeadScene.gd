extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = $ColorRect/VBoxContainer/Btn_Restart.connect("pressed", self, "_on_btn_restart_pressed")
	__ = $ColorRect/VBoxContainer/Btn_ExitToTitle.connect("pressed", self, "_on_btn_exittotitle_pressed")
	
func _on_btn_restart_pressed():
	get_tree().change_scene("res://Scene/Levels/level.tscn")
	
func _on_btn_exittotitle_pressed():
	get_tree().change_scene("res://Scene/Levels/TitleScreen.tscn")
