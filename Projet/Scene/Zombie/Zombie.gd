##########
# ZOMBIE #
##########


### EXPANSION ###

extends KinematicBody2D
class_name Zombie


### GLOBAL VARIABLE ###
onready var state_machine = get_node("StateMachine")
onready var cooldown_grab = $CooldownGrab
onready var chase_area = $ChaseArea
onready var attack_area = $AttackArea
onready var animated_Sprite = $AnimatedSprite
onready var HP_bar = get_node("Health_Bar/TextureProgress")
onready var Hit_Box = get_node("HitBox")
onready var sandbox_hurt = get_node("Soundbox/Hurt")

var target : Node2D = null
var speed : float = 60
var max_HP : int = 3
var current_HP : int = 3

var canGrab : bool = false

var target_in_chase_area : bool = false setget set_target_in_chase_area
var target_in_attack_area : bool = false setget set_target_in_attack_area



### SIGNALS ###

signal value_target_null
signal can_attack

signal HP_changed


   ### ACCESSORS ###

func set_target_in_chase_area(value : bool):
	if value != target_in_chase_area:
		target_in_chase_area = value
		_update_target()
		
func set_target_in_attack_area(value : bool):
	if value != target_in_attack_area:
		target_in_attack_area = value
		_update_target()
	
	pass




 ### BUILT-IN ###
   

### BUILT_IN ###

func _ready():
	state_machine.set_state("Spawn")
	
	HP_bar.set_max(max_HP)
	HP_bar.set_value(current_HP)
	$AnimatedSprite.z_index = -1
	$AnimatedSprite.modulate.a = 0.90
	_update_animation()
	
	
	var __ = chase_area.connect("body_entered",self,"_on_ChaseArea_body_entered")
	__ = chase_area.connect("body_exited",self,"_on_ChaseArea_body_exited")
	__ = attack_area.connect("body_entered", self,"_on_AttackArea_body_entered")
	__ = attack_area.connect("body_exited", self, "_on_AttackArea_body_exited")
	__ = connect("value_target_null", self, "_on_value_target_null")
	__ = state_machine.connect("state_changed", self, "_on_state_changed")
	__ = connect ("can_attack", self, "_on_can_attack")
	__ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
	__ = connect("HP_changed", self, "_on_HP_changed")
	__ = cooldown_grab.connect("timeout", self, "_on_timeout_cooldown_grab")
	
func _physics_process(_delta):
#	$Health_Bar/Label.text = str(state_machine.current_state)
	if current_HP <= 0 : state_machine.set_state("Die")
	
	if state_machine.get_state_name() == "Move":
		var dir = (target.position - position).normalized()
		var move = dir * speed
		var _dir_move = move_and_slide(move)
		look_at(target.position)

	if state_machine.get_state_name() == "Grab":

		var dir = (target.position - self.position).normalized()
		var move = dir * (speed +40)
		var _dir_move = move_and_slide(move)
		look_at(target.position)
	
   ### LOGICS ###		


func _update_target():
	if !target_in_attack_area && !target_in_chase_area:
		emit_signal("value_target_null")
	elif target_in_chase_area && !target_in_attack_area:
		state_machine.set_state("Move")
	elif target_in_chase_area && target_in_attack_area:
		emit_signal("can_attack")
		
	
	
	
func _update_sound ():
	
	match (state_machine.get_state_name()):
		"Hurt" : sandbox_hurt.play()
		
func _update_animation ():
	var state_name = state_machine.get_state_name()	
	animated_Sprite.play(state_name)
	
func hurt (damage : int):
	
	current_HP += - damage
	emit_signal("HP_changed")
	state_machine.set_state("Hurt")


### SIGNALS RESPONSES ###

func _on_state_changed(new_state : Node):	
	match (new_state.name):

		"Die" :
			$Health_Bar/TextureProgress.visible = false
			$ChaseArea/CollisionShape2D.disabled = true
			$HitBox.disabled = true	
			$AnimatedSprite.z_index = -1
			$AnimatedSprite.modulate.a = 0.90
	
			
	_update_animation()
	_update_sound()
	
	
func _on_ChaseArea_body_entered(body : Node2D):
	if body is Character :
		set_target_in_chase_area(true)
		target = body
func _on_ChaseArea_body_exited(body : Node2D):
	if body is Character :
		set_target_in_chase_area(false)

func _on_AttackArea_body_entered(body : Node2D):
	if body is Character:
		set_target_in_attack_area(true)
		target = body
	pass

func _on_AttackArea_body_exited(body : Node2D):
	if body is Character :
		set_target_in_attack_area(false)
	pass
func _on_AnimatedSprite_animation_finished():

	match(state_machine.get_state_name()):

		"Idle" : 
			if target_in_chase_area: state_machine.set_state("Move")
			if !cooldown_grab.start() : cooldown_grab.start ()
			
		"Spawn" : 
			$ChaseArea/CollisionShape2D.disabled = false
			$AttackArea/CollisionShape2D.disabled = false
			$HitBox.disabled = false
			$AnimatedSprite.z_index = 0
			$AnimatedSprite.modulate.a = 1.0
			cooldown_grab.start()
			state_machine.set_state("Idle")	
		"Move" : if target_in_attack_area : _update_target()
		
		"Hurt" : 
			if current_HP <= 0 : state_machine.set_state("Die")
			elif target_in_chase_area: state_machine.set_state("Move")
			else : state_machine.set_state("Idle")	
			
		"Grab":
			target.is_grab(self)
			canGrab = false
			cooldown_grab.start()
			state_machine.set_state("Attack")
			
		"Attack" : 
			if target.body_target != self: state_machine.set_state("Idle")
			else : state_machine.set_state("Grab")
		"Die" : queue_free()	
		
func _on_HP_changed():
	HP_bar.visible = true
	HP_bar.set_value(current_HP)	
func _on_value_target_null():
	match (state_machine.current_state):
		"Die" : pass
		"Move" : state_machine.set_state("Idle") 
		
func _on_timeout_cooldown_grab():
	canGrab = true
	_update_target()
	
func _on_can_attack():
	if canGrab && target.canGrab :
		state_machine.set_state("Grab")
