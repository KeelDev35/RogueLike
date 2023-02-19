extends CanvasLayer

var paused := false
var wave_max
var current_wave = 1
func _ready():
	var __ = $ColorRect/VBoxContainer/Btn_resume.connect("pressed", self, "_on_btn_resume_pressed")
	__ = $ColorRect/VBoxContainer/Btn_restart.connect("pressed", self,"_on_btn_restart_pressed")
	__ = $ColorRect/VBoxContainer/Btn_ExitToTitle.connect("pressed", self, "_on_btn_exitToTitle_pressed")
	__ = get_parent().get_node("SpawnManager").connect("wave_finish", self, "_on_wave_finish")
	wave_max = get_parent().get_node("SpawnManager").get_child_count() -1 
	$Wave_count.set_text("waves : " + str(current_wave) + ":" + str(wave_max))

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_take_pause()

func _on_btn_resume_pressed():
	_take_pause()
	pass

func _on_btn_restart_pressed():
	_take_pause()
	var __ = get_tree().change_scene("res://Scene/Levels/level.tscn")
	pass
	
func _on_btn_exitToTitle_pressed():
	_take_pause()
	var __ = get_tree().change_scene("res://Scene/Levels/TitleScreen.tscn")
	
	
func _take_pause():
	
	paused = !paused
	$ColorRect.visible = paused
	get_tree().set_pause(paused)
	
func _on_wave_finish():
	current_wave = current_wave +1
	
	if current_wave > wave_max:
		$Wave_count.add_color_override("font_color", Color(0,1,0,1))
		$Wave_count.set_text("Room completed")
	else:
		$Wave_count.set_text("waves : " + str(current_wave) + ":" + str(wave_max))
