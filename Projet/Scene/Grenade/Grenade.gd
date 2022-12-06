###########
# GRENADE #
###########


### EXPANSION ###
extends RigidBody2D


### ENUMERATION ####

enum STATE{
	IDLE,
	EXPLOSION,
}


   ### GLOBAL VARIABLE ###

onready var Animated_Sprite = get_node("AnimatedSprite")
onready var Sandbox_Explosion = get_node("Sandbox/Explosion")
onready var Grenade_Collider = get_node("Collider")
onready var Detection_Box = get_node("DetectionBox")
onready var Explosion_Hit_Box = get_node("ExplosionHitBox")
onready var Timer_Explosion = get_node("TimerExplosion")

var state : int = STATE.IDLE setget set_state, get_state

var damage : int = 3


   ### SINGALS ###

signal state_changed


   ### ACCESSORS ###

func set_state(value: int):
	if (value != state) :
		state = value
		emit_signal("state_changed")
func get_state() -> int:
	
	return state


   ### BUILT_IN ###

func _ready():
	set_state(STATE.IDLE)
	Timer_Explosion.start()
	var __ = connect("state_changed",self,"_on_state_changed")
	__ = Timer_Explosion.connect("timeout",self, "_on_TimerExplosion_timeout")
	__ = Sandbox_Explosion.connect("finished",self,"_on_sandbox_finished")
	__ = Detection_Box.connect("body_entered", self, "_on_body_entered")	
func _process(_delta):
	
	if state == STATE.IDLE :
		self.apply_central_impulse(-linear_velocity *0.05)



   ### LOGICS ###
func _update_animation () -> void:
	match (state):
		STATE.IDLE : Animated_Sprite.play("Idle")
		STATE.EXPLOSION : 
			self.linear_velocity = Vector2.ZERO
			self.angular_velocity = 0
			Animated_Sprite.play("Explosion")
	pass
func _update_sound() -> void:
	match (state):
		STATE.EXPLOSION : Sandbox_Explosion.play()

func _attack_effect():
	var body_array = Explosion_Hit_Box.get_overlapping_bodies()
	
	for body in body_array:
		if body == self :
			continue
		
		if body.has_method("hurt"):
			body.hurt(damage)


### SIGNAL RESPONSES ###

func _on_state_changed():
	_update_animation()
	_update_sound()
func _on_TimerExplosion_timeout():
	set_state(STATE.EXPLOSION)
	_attack_effect()
func _on_sandbox_finished():
	queue_free()
func _on_body_entered(body : Node2D):
		if body.has_method("hurt") and state == STATE.IDLE:
			Timer_Explosion.stop()
			Timer_Explosion.wait_time = 0.05
			Timer_Explosion.start()
	
	
	
