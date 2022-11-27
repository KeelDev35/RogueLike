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
onready var Timer_Explosion = get_node("TimerExplosion")


var state : int = STATE.IDLE setget set_state, get_state

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
	
	Timer_Explosion.start()
	var __ = connect("state_changed",self,"_on_state_changed")
	__ = Timer_Explosion.connect("timeout",self, "_on_TimerExplosion_timeout")
	__ = Sandbox_Explosion.connect("finished",self,"_on_sandbox_finished")
	

	
	
	



   ### LOGICS ###
func update_animation () -> void:
	match (state):
		STATE.IDLE : Animated_Sprite.play("Idle")
		STATE.EXPLOSION : Animated_Sprite.play("Explosion")
	pass
func update_sound() -> void:
	match (state):
		STATE.EXPLOSION : Sandbox_Explosion.play()

func _on_state_changed():
	update_animation()
	update_sound()
func _on_TimerExplosion_timeout():
	set_state(STATE.EXPLOSION)
func _on_sandbox_finished():
	queue_free()
