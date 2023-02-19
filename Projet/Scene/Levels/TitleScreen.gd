extends Control


func _ready():
	var __ = $ColorRect/VBoxContainer/Btn_Start.connect("pressed", self ,"_on_btn_Start_pressed")
	__ = $ColorRect/VBoxContainer/Btn_ExitToDesktop.connect("pressed", self,"_on_btn_ExitToDesktop_pressed")
	




func _on_btn_Start_pressed():
	var __ = get_tree().change_scene("res://Scene/Levels/level.tscn")
	pass
	
func _on_btn_ExitToDesktop_pressed():
	get_tree().quit()

