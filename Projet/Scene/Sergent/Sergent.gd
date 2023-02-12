###############
### SERGENT ###
###############


### EXPENSION ###

extends H_Character
class_name Sergent


### GLOBAL_VARIABLE ###

onready var HP_bar = $HUD/Health_Bar/TextureProgress
onready var bullet_point = $InstancePoints/BulletPoint
#onready var target_hit = get_tree()_get_root().get_node("Player/InstancePoints/HitPoint")

var bullet = preload("res://Scene/Bullet/bullet.tscn")
var bullet_speed = 800

var dir_move = Vector2.ZERO


### BUILT_IN ###

func _ready():
	var __ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
	__ = connect("target_in_attack_area", self, "_on_target_in_attack_area")
	__ = animated_sprite.connect("frame_changed", self, "_on_AnimatedSprite_frame_changed")
		
	target = get_node("/root/Debug/Player")

### LOGICS ###
func _update_sound ():
	match (state_machine.get_state_name()):
		"Attack" : $SoundBox/Attack.play()
		"Draw" : $SoundBox/Reload.play()
		"Die" : $SoundBox/Die.play()
		"Hurt" : $SoundBox/Hurt.play()



func _attack_effect() :
	var bullet_instance = bullet.instance()
	bullet_instance.position = bullet_point.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
	bullet_instance.set_collision_mask_bit(4, true)
	bullet_instance.set_collision_mask_bit(1, false)
	get_tree().get_root().add_child(bullet_instance)


### LOGICS_STATES ###

func _spawn_enter_state():
	$Areas/AttackArea/CollisionShape2D.disabled = true
	$SelfHitBox.disabled = true
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.9
	pass
func _spawn_exit_state():
	HP_bar.set_max(max_HP)
	HP_bar.set_value(current_HP)
	$Areas/AttackArea/CollisionShape2D.disabled = false
	$SelfHitBox.disabled = false
	$AnimatedSprite.z_index = 0
	$AnimatedSprite.modulate.a = 1.0

func _move_update_state(sp : float):
		var dir = (target.position - position).normalized() * sp
		dir_move = move_and_slide(dir)
		look_at(target.position)

func _draw_update_state():
#	look_at(target_hit.global_position)
	look_at(target.global_position)
	pass

func _hurt_update_state():
	HP_bar.visible = true
	HP_bar.set_value(current_HP)

func _die_enter_state():
	$Areas/AttackArea/CollisionShape2D.disabled = true
	$HUD/Health_Bar/TextureProgress.visible = false
	$SelfHitBox.disabled = true	
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.90
	
### SIGNALS RESPONSES ###


func _on_AnimatedSprite_animation_finished():

	match(state_machine.get_state_name()):
		"Spawn" : state_machine.set_state("Move")
#
		"Move" : if target_in_attack_area : state_machine.set_state("Draw")
		
		"Hurt" : _checking_life()

		"Draw" : 
			if target_in_attack_area : state_machine.set_state("Attack")
			else : state_machine.set_state("Move")
			
		"Attack" : 
			if target_in_attack_area : state_machine.set_state("Draw")
			else : state_machine.set_state("Move")

			
		"Die" : queue_free()

func _on_target_in_attack_area():
	pass

func _on_AnimatedSprite_frame_changed():
	if "Attack".is_subsequence_of(animated_sprite.get_animation()) :
		if animated_sprite.get_frame() == 2:
			_attack_effect()
	
	if "Move".is_subsequence_of(animated_sprite.get_animation()) :
		if target_in_attack_area :
			state_machine.set_state("Draw")
