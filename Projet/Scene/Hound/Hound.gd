#############
### HOUND ###
#############


### EXPENSION ###

extends H_Character
class_name Hound


### GLOBAL_VARIABLE ###

onready var HP_bar = $HUD/Health_Bar/TextureProgress

var dir_move = Vector2.ZERO
var timer_cooldown_attack = Timer.new()
var cooldown_attack = 5.0
var can_attack : bool = false
var dir_attack
var speed_attack = 150

signal can_attack


### BUILT_IN ###

func _ready():
	var __ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
	__ = connect("target_in_attack_area", self, "_on_target_in_attack_area")
	__ = connect("can_attack", self, "_on_can_attack")
	__ = $Areas/AttackHitBox.connect("body_entered", self,"_on_body_entered_in_attack_hitbox")



	add_child(timer_cooldown_attack)
	timer_cooldown_attack.one_shot = true
	timer_cooldown_attack.connect("timeout", self,"_on_timer_cooldown_attack")



### LOGICS ###

func _update_sound ():
	match (state_machine.get_state_name()):
		"Attack" : $SoundBox/Attack.play()
		"Die" : $SoundBox/Die.play()
		"Hurt" : $SoundBox/Hurt.play()

func _activable_attack_hitbox ():
	$Areas/AttackHitBox/CollisionShape2D.disabled = true
	
#func _hurt_feedback():
#	pass
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

func _idle_update_state():
	look_at(target.position)

func _move_update_state(sp : float):
	var dir = (target.position - position).normalized() * sp
	dir_move = move_and_slide(dir)
	look_at(target.position)

func _attack_enter_state():
	can_attack = false
	look_at(target.position)
	dir_attack = (target.position - position).normalized() * speed_attack
	set_collision_mask_bit(4, false)
	$Areas/AttackHitBox/CollisionShape2D.disabled = false
	
func _attack_update_state():
	dir_move = move_and_slide(dir_attack)
	
	
func _attack_exit_state():
	timer_cooldown_attack.start(cooldown_attack)

	set_collision_mask_bit(4, true)
	call_deferred("_activable_attack_hitbox")
	

func _hurt_update_state():
	HP_bar.visible = true
	HP_bar.set_value(current_HP)

func _die_enter_state():
	$Areas/AttackArea/CollisionShape2D.disabled = true
	$HUD/Health_Bar/TextureProgress.visible = false
	$SelfHitBox.disabled = true	
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.90


### SIGNALS_RESPONSES ###

func _on_AnimatedSprite_animation_finished():
	match(state_machine.get_state_name()):
		"Spawn" : 
			timer_cooldown_attack.start(cooldown_attack)
			state_machine.set_state("Idle")
		"Idle" : if can_attack : state_machine.set_state("Move")
		
		"Move" : if target_in_attack_area : emit_signal("can_attack")
		
		"Hurt" : _checking_life()
		
		"Attack" : 
			state_machine.set_state("Idle")
			
		"Die" :
			queue_free()

func _on_can_attack():
	state_machine.set_state("Attack")

func _on_timer_cooldown_attack():
	can_attack = true
	pass

func _on_body_entered_in_attack_hitbox(body):
	if body is Player :
		body.hit(damage)

func _on_target_in_attack_area():
	pass
