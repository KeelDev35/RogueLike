###################
### H_Character ###
###################


### EXPANSION ###

extends KinematicBody2D
class_name H_Character


### GLOBAL VARIABLE ###

onready var state_machine = $StateMachine
onready var animated_sprite = $AnimatedSprite
#onready var attack_hit_box = $Hitboxs/AttackHitbox
onready var attack_area = $Areas/AttackArea
onready var tween = $Tween

export var speed : = 0
export var max_HP : = 0
export var current_HP : = 0
export var damage : = 0

var target : Node2D = null
var damage_taken : = 0


var target_in_attack_area : bool = false setget set_target_in_attack_area


### SIGNALS ###


signal target_in_attack_area

### ACCESSORS ###
func set_target_in_attack_area(value : bool):
	if value != target_in_attack_area:
		target_in_attack_area = value
		_update_target()
	
	pass


### BUILT_IN ###

func _ready():
	var __ = attack_area.connect("body_entered", self,"_on_AttackArea_body_entered")
	__ = attack_area.connect("body_exited", self, "_on_AttackArea_body_exited")
	__ = state_machine.connect("state_changed", self, "_on_state_changed")
	
	state_machine.set_state("Spawn")


#func _process(_delta):
#	if current_HP <= 0 : state_machine.set_state("Die")

### LOGICS ###

func _update_animation ():
	var state_name = state_machine.get_state_name()	
	animated_sprite.play(state_name)
func _update_sound ():
	pass

func hit(damage : int):
	damage_taken = damage
	state_machine.set_state("Hurt")
	
func _hurt_feedback():
	tween.interpolate_property(animated_sprite.material, "shader_param/opacity", 0.0, 1.0, 0.1)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(animated_sprite.material, "shader_param/opacity", 1.0, 0.0, 0.1)
	tween.start()
	
func _update_target():
	if target_in_attack_area:
		emit_signal("target_in_attack_area")

func _checking_life():
	yield(get_tree().create_timer(0.1), "timeout")
	if current_HP <= 0 : state_machine.set_state("Die")
	elif current_HP >= 1 : state_machine.set_state("Move")	
	
### LOGICS STATES ###

func _hurt_enter_state():
	current_HP += - damage_taken
	_hurt_feedback()



### SIGNALS RESPONSES ###

func _on_state_changed(_new_state : Node):		
	_update_animation()
	_update_sound()


func _on_AttackArea_body_entered(body : Node2D):
	if body is Player:
		set_target_in_attack_area(true)
		target = body
	pass
func _on_AttackArea_body_exited(body : Node2D):
	if body is Player :
		set_target_in_attack_area(false)
	pass


