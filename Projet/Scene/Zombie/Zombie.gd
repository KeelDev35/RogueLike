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
onready var grab_area = $Areas/GrabArea


var dir_move = Vector2.ZERO

var speed_grab : float = 100
var canGrab : bool = false


### BUILT_IN ###

func _ready():
	var __ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
#	__ = connect("HP_changed", self, "_on_HP_changed")
	__ = cooldown_grab.connect("timeout", self, "_on_timeout_cooldown_grab")
	__ = connect("target_in_attack_area", self, "_on_target_in_attack_area")
	
	target = get_node("../Player")


### LOGICS ###		

func _checking_life():
	if current_HP >= 1 : state_machine.set_state("Move")	
	elif current_HP <= 0 : state_machine.set_state("Die")
	
func _update_sound ():
	match (state_machine.get_state_name()):
		"Hurt" : sandbox_hurt.play()
		"Die" : sandbox_hurt.play()

func _try_to_grab():
	var bodies_array = grab_area.get_overlapping_bodies()
	
	for body in bodies_array:
		if body == self:
			continue
		
		
		if body is Player && body.body_target == null:
			body.is_grab()
			body.body_target = self
			body.look_at(self.position)
			state_machine.set_state("Attack")

func can_hit(value : int):
	hit(value)
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
	cooldown_grab.start()

func _move_update_state(sp : float):
		var dir = (target.position - position).normalized() * sp
		dir_move = move_and_slide(dir)
		look_at(target.position)
		
func _attack_update_state():
	_move_update_state(speed)


func _hurt_update_state():
	HP_bar.visible = true
	HP_bar.set_value(current_HP)

func _grab_update_state():
	_move_update_state(speed_grab)
	
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
		"Move" : if target_in_attack_area : _update_target()
		
		"Hurt" : _checking_life()

		"Grab":
			cooldown_grab.start()
			canGrab = false
			_try_to_grab()
			if state_machine.get_state_name()!= "Attack":
				state_machine.set_state("Move")

		"Attack" : 
			if target.has_method("hit") && target.body_target == self :
				target.hit(damage)
				var velocity = (target.global_position - self.global_position).normalized()
				target.move_and_slide(velocity * 1000)
				
			state_machine.set_state("Move")
			
		"Die" : queue_free()

func _on_timeout_cooldown_grab():
	canGrab = true
	_update_target()

func _on_target_in_attack_area():
	yield(get_tree().create_timer(randf()), "timeout")
	if canGrab && target.canGrab :
		state_machine.set_state("Grab")
	else : pass
