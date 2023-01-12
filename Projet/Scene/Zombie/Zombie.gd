##########
# ZOMBIE #
##########


### EXPANSION ###

extends H_Character
class_name Zombie


### GLOBAL VARIABLE ###

onready var cooldown_grab = $Cooldowns/CooldownGrab
onready var HP_bar = $HUD/Health_Bar/TextureProgress
onready var sandbox_hurt =$SoundBox/Hurt

var dir_move = Vector2.ZERO

var speed_grab : float = 100
var canGrab : bool = false


### BUILT_IN ###

func _ready():
	var __ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
#	__ = connect("HP_changed", self, "_on_HP_changed")
	__ = cooldown_grab.connect("timeout", self, "_on_timeout_cooldown_grab")
	__ = connect("target_in_chase_area", self, "_on_target_in_chase_area")
	__ = connect("target_in_attack_area", self, "_on_target_in_attack_area")
	
### LOGICS ###		

func _update_sound ():
	match (state_machine.get_state_name()):
		"Hurt" : sandbox_hurt.play()
		"Die" : sandbox_hurt.play()
	
### LOGICS_STATES ###
func _spawn_enter_state():
	$Areas/ChaseArea/CollisionShape2D.disabled = true
	$Areas/AttackArea/CollisionShape2D.disabled = true
	$SelfHitBox.disabled = true
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.9
	pass
func _spawn_exit_state():
	HP_bar.set_max(max_HP)
	HP_bar.set_value(current_HP)
	$Areas/ChaseArea/CollisionShape2D.disabled = false
	$Areas/AttackArea/CollisionShape2D.disabled = false
	$SelfHitBox.disabled = false
	$AnimatedSprite.z_index = 0
	$AnimatedSprite.modulate.a = 1.0
	cooldown_grab.start()

func _move_update_state(sp : float):
		var dir = (target.position - position).normalized() * sp
		dir_move = move_and_slide(dir)
		look_at(target.position)

func _hurt_update_state():
	HP_bar.visible = true
	HP_bar.set_value(current_HP)
func _grab_update_state():
	_move_update_state(speed_grab)
	pass
func _die_enter_state():
	$HUD/Health_Bar/TextureProgress.visible = false
	$Areas/ChaseArea/CollisionShape2D.disabled = true
	$SelfHitBox.disabled = true	
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.90
### SIGNALS RESPONSES ###

func _on_AnimatedSprite_animation_finished():

	match(state_machine.get_state_name()):


		"Spawn" : state_machine.set_state("Idle")
		"Idle" : 
			if target_in_chase_area: state_machine.set_state("Move")
			if !cooldown_grab.start() : cooldown_grab.start ()
			

		"Move" : if target_in_attack_area : _update_target()
		
		"Hurt" : 
			if target_in_chase_area: state_machine.set_state("Move")
			else : state_machine.set_state("Idle")	
			
		"Grab":
			target.is_grab(self)
			canGrab = false
			cooldown_grab.start()
			yield(get_tree().create_timer(2.0), "timeout")
			state_machine.set_state("Attack")
			
		"Attack" : 
			if target.has_method("hit") :
				target.hit(damage)
				var velocity = (target.global_position - self.global_position).normalized()
				target.move_and_slide(velocity * 1000)
				
				
			state_machine.set_state("Idle")
			
			
		"Die" : queue_free()
		
func _on_timeout_cooldown_grab():
	canGrab = true
	_update_target()
func _on_target_in_chase_area():
	state_machine.set_state("Move")

func _on_target_in_attack_area():
	if canGrab && target.canGrab :
		state_machine.set_state("Grab")
	else : pass
