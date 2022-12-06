##########
# ZOMBIE #
##########


### EXPANSION ###

extends KinematicBody2D
class_name Zombie


### ENUMERATION ###

enum STATE {
	SPAWN,
	IDLE,
	MOVE,
	HURT,
	DIE,
	}
	

### GLOBAL VARIABLE ###

onready var chase_area = $ChaseArea
onready var animated_Sprite = $AnimatedSprite
onready var HP_bar = get_node("AnimatedSprite/Health_Bar/TextureProgress")
onready var Hit_Box = get_node("HitBox")
onready var sandbox_hurt = get_node("Soundbox/Hurt")

var target : Node2D = null
var speed : float = 70
var max_HP : int = 3
var current_HP : int = 3

var target_in_chase_area : bool =false setget set_target_in_chase_area
var state : int = STATE.SPAWN setget set_state, get_state


### SIGNALS ###

signal value_target_null
signal state_changed
signal HP_changed


   ### ACCESSORS ###

func set_target_in_chase_area(value : bool):
	if value != target_in_chase_area:
		target_in_chase_area = value
		_updated_target()
func set_state (value:int) -> void :
		if (value != state) :
			state = value
			
		emit_signal("state_changed")
func get_state () -> int :
	return state


 ### BUILT-IN ###

func _ready():

	HP_bar.set_max(max_HP)
	HP_bar.set_value(current_HP)
	_update_animation()
	
	
	var __ = chase_area.connect("body_entered",self,"_on_ChaseArea_body_entered")
	__ = connect("state_changed", self, "_on_state_changed")
	__ = chase_area.connect("body_exited",self,"_on_ChaseArea_body_exited")
	__ = $AnimatedSprite.connect("animation_finished",self, "_on_AnimatedSprite_animation_finished")
	__ = connect("HP_changed", self, "_on_HP_changed")
	__ = connect("value_target_null", self, "_on_value_target_null")
func _physics_process(_delta):

	if state == STATE.MOVE:
		var dir = (target.position - position).normalized()
		var move = dir * speed
		var _dir_move = move_and_slide(move)
		look_at(target.position)


   ### LOGICS ###		

func _updated_target():
	if !target_in_chase_area:
		target = null
		emit_signal("value_target_null")
func _update_sound ():
	
	match (state):
		STATE.HURT : sandbox_hurt.play()
func _update_animation ():

	var state_name 
	
	match (state) :
		STATE.SPAWN : state_name = "Spawn"
		STATE.IDLE : state_name = "Idle"
		STATE.MOVE : state_name = "Move"
		STATE.HURT : state_name = "Hurt"
		STATE.DIE  : 
			state_name = "Die"
			
			
		
	animated_Sprite.play(state_name)
func hurt (damage : int):
	
	current_HP += - damage
	emit_signal("HP_changed")
	set_state(STATE.HURT)


### SIGNALS RESPONSES ###

func _on_state_changed():	
	match (state):
		STATE.SPAWN : 
			$ChaseArea/CollisionShape2D.disabled = true
			$HitBox.disabled = true
			
		
		STATE.DIE :
			$ChaseArea/CollisionShape2D.disabled = true
			$HitBox.disabled = true	
			self.z_index = -1
	
			
	_update_animation()
	_update_sound()
func _on_ChaseArea_body_entered(body : Node2D):
	if body is Character :
		set_target_in_chase_area(true)
		target = body
func _on_ChaseArea_body_exited(body : Node2D):
	if body is Character :
		set_target_in_chase_area(false)
func _on_AnimatedSprite_animation_finished():
	
	match(state):

		STATE.IDLE : if target_in_chase_area: set_state(STATE.MOVE)
		STATE.SPAWN : 
			$ChaseArea/CollisionShape2D.disabled = false
			$HitBox.disabled = false
			self.z_index = 0
			set_state(STATE.IDLE)	
		STATE.HURT : 
			if current_HP <= 0 : set_state(STATE.DIE)
			else : set_state(STATE.IDLE)
				
		STATE.DIE : queue_free()	
func _on_HP_changed():
	HP_bar.visible = true
	HP_bar.set_value(current_HP)	
func _on_value_target_null():
	match (state):
		STATE.DIE : pass
		STATE.MOVE : set_state(STATE.IDLE) 
