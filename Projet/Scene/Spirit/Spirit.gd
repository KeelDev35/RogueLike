extends H_Character
class_name Spirit


var dir_move = Vector2.ZERO
var timer_time_life = Timer.new()
var time_life = 5

onready var hound = preload("res://Scene/Hound/Hound.tscn")

func _ready():
	var __ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
	__ = connect("target_in_attack_area", self, "_on_target_in_attack_area")
	__ = animated_sprite.connect("frame_changed", self, "_on_AnimatedSprite_frame_changed")
	target = get_node("/root/Debug/Player")
	add_child(timer_time_life)
	timer_time_life.one_shot = true
	timer_time_life.connect("timeout", self, "_on_timer_timeout")
	
	
	
	
func _update_sound ():
	match (state_machine.get_state_name()):
		"Attack" : $SoundBox/Attack.play()
		"Die" : $SoundBox/Die.play()
		"Move" : $SoundBox/Move.play()

func _attack_effect():
	var hound_instance = hound.instance()
	hound_instance.position = $Spawn_point.get_global_position()
	hound_instance.can_attack = true
	hound_instance.cooldown_attack = 2.0
	get_tree().get_root().add_child(hound_instance)	
	
	var hound_instance2 = hound.instance()
	hound_instance2.position = $Spawn_point2.get_global_position()
	hound_instance2.can_attack = true
	hound_instance2.cooldown_attack = 2.0
	get_tree().get_root().add_child(hound_instance2)

func _spawn_enter_state():

	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.9
	
func _spawn_exit_state():

	$AnimatedSprite.z_index = 2
	$AnimatedSprite.modulate.a = 1.0
	
func _move_update_state(sp : float):
	var dir = (target.position - position).normalized() * sp
	dir_move = move_and_slide(dir)
	look_at(target.position)
	

func _attack_enter_state():
	timer_time_life.stop()

func _die_enter_state():
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.90
	

func _on_AnimatedSprite_animation_finished():
	match(state_machine.get_state_name()):
		"Spawn" : 
			timer_time_life.start(time_life)
			state_machine.set_state("Move")
		
		"Move" : if target_in_attack_area : state_machine.set_state("Attack")
		
		"Attack" : 
			state_machine.set_state("Die")
			
		"Die" : queue_free()

func _on_timer_timeout():
		state_machine.set_state("Die") 
	
func _on_AnimatedSprite_frame_changed():
	if "Attack".is_subsequence_of(animated_sprite.get_animation()) :
		if animated_sprite.get_frame() == 6:
			print(animated_sprite.get_frame())
			_attack_effect()

func _on_target_in_attack_area():
	pass
