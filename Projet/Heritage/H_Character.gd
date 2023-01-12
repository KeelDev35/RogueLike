###################
### H_Character ###
###################


### EXPANSION ###

extends KinematicBody2D
class_name H_Character


### GLOBAL VARIABLE ###

onready var state_machine = $StateMachine
onready var animated_sprite = $AnimatedSprite
onready var attack_hit_box = $Hitboxs/AttackHitbox
onready var chase_area = $Areas/ChaseArea
onready var attack_area = $Areas/AttackArea

export var speed : = 0
export var max_HP : = 0
export var current_HP : = 0
export var damage : = 0

var target : Node2D = null
var damage_taken : = 0

var target_in_chase_area : bool = false setget set_target_in_chase_area
var target_in_attack_area : bool = false setget set_target_in_attack_area


### SIGNALS ###

signal value_target_null
signal target_in_chase_area
signal target_in_attack_area

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


### BUILT_IN ###

func _ready():
	state_machine.set_state("Spawn")

	
	var __ = chase_area.connect("body_entered",self,"_on_ChaseArea_body_entered")
	__ = chase_area.connect("body_exited",self,"_on_ChaseArea_body_exited")
	__ = attack_area.connect("body_entered", self,"_on_AttackArea_body_entered")
	__ = attack_area.connect("body_exited", self, "_on_AttackArea_body_exited")
	__ = connect("value_target_null", self, "_on_value_target_null")
	__ = state_machine.connect("state_changed", self, "_on_state_changed")


### LOGICS ###

func _update_animation ():
	var state_name = state_machine.get_state_name()	
	animated_sprite.play(state_name)
func _update_sound ():
	pass

func hit(damage : int):
	damage_taken = damage
	state_machine.set_state("Hurt")

func _update_target():
	if !target_in_attack_area && !target_in_chase_area:
		emit_signal("value_target_null")
	elif target_in_chase_area && !target_in_attack_area:
		emit_signal("target_in_chase_area")
#		state_machine.set_state("Move")
	elif target_in_chase_area && target_in_attack_area:
		emit_signal("target_in_attack_area")

### LOGICS STATES ###

func _hurt_enter_state():
	current_HP += - damage_taken
	if current_HP <= 0 : state_machine.set_state("Die")	


### SIGNALS RESPONSES ###

func _on_state_changed(_new_state : Node):		
	_update_animation()
	_update_sound()

func _on_ChaseArea_body_entered(body : Node2D):
	if body is Player :
		set_target_in_chase_area(true)
		target = body
func _on_ChaseArea_body_exited(body : Node2D):
	if body is Player :
		set_target_in_chase_area(false)

func _on_AttackArea_body_entered(body : Node2D):
	if body is Player:
		set_target_in_attack_area(true)
		target = body
	pass
func _on_AttackArea_body_exited(body : Node2D):
	if body is Player :
		set_target_in_attack_area(false)
	pass

func _on_value_target_null():
	match (state_machine.current_state):
		"Die" : pass
		"Move" : state_machine.set_state("Idle") 
