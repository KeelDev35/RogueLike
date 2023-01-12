
#############
### PLAYER ##
#############

### EXPANSION ###

extends KinematicBody2D
class_name Player


### ENUMERATION ###

enum STATE {
	IDLE,
	FIRE,
	RELOAD,
	MELEE,
	HURT,
	DEAD,
	GRENADE,
	}


### GLOBAL VARIABLE ###

onready var Animated_Sprite = get_node("AnimatedSprite")

onready var Sandbox_Fire = get_node("SoundBox/Fire")
onready var Sandbox_Walk_sand = get_node("SoundBox/walk_sand")
onready var Sandbox_Reload = get_node("SoundBox/Reload")
onready var Sandbox_Melee = get_node("SoundBox/Melee")
onready	var	Sandbox_Pin_Grande = get_node("SoundBox/Pin_Grenade")

onready var Cooldown_Grenade = get_node("Cooldowns/CooldownGrenade")
onready var Cooldown_Melee = get_node("Cooldowns/CooldownMelee")
onready var Cooldown_Shoot = get_node("Cooldowns/CooldownShoot")
onready var Cooldown_CanGrab = get_node("Cooldowns/CooldownCanGrab")

onready var Melee_Hitbox = get_node("AttackMeleeHitbox")

onready var Bullet_Point = get_node("InstancePoints/BulletPoint")
onready var Grenade_Point = get_node("InstancePoints/GrenadePoint")

export var bullet_speed = 1000
export var grenade_speed = 250

var state : int = STATE.IDLE setget set_state, get_state
var walk :bool setget	set_is_walking, get_is_walking

var bullet = preload("res://Scene/Bullet/bullet.tscn")
var grenade = preload("res://Scene/Grenade/Grenade.tscn")

var damage_taken : = 0
var speed = 100
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var meleeDamage : int = 1
var canShoot = true
var canMelee = true
var canGrenade = true
var canGrab = true
var isGrab = false 

var body_target : Node2D = null

### SIGNALS ###

signal is_walking_changed
signal state_changed


### ACCESSORS ###

func set_state (value:int) -> void :
		if (value != state) :
			state = value
			
		emit_signal("state_changed")
func get_state () -> int :
	
	return state

func set_is_walking(value : bool) : # 
	
	if value != walk :
		walk = value
		emit_signal("is_walking_changed")
func get_is_walking() :
	return walk


### BUILT-IN ###

func _ready() -> void: # Called when the node enters the scene tree for the first time.

	var __ = connect("is_walking_changed", self, "_on_is_walking_changed")
	__ = connect ("state_changed", self, "_on_state_changed")
	__ = Animated_Sprite.connect ("animation_finished", self, "_on_Sprite_animation_finished")
	__ = Animated_Sprite.connect ("frame_changed", self, "_on_melee_frame_changed")
	__ = Cooldown_Grenade.connect("timeout",self, "_on_timeout_cooldown_grenade")
	__ = Cooldown_Melee.connect("timeout", self, "_on_timeout_cooldown_melee")
	__ = Cooldown_Shoot.connect("timeout", self, "_on_timeout_cooldown_shoot")
	__ = Cooldown_CanGrab.connect("timeout", self, "_on_timeout_cooldown_canGrab")

func _process(_delta : float) -> void: # main process function
	velocity = move_and_slide(direction * speed) 
	if !isGrab:
		look_at(get_global_mouse_position())


	
	
func _input(_event:InputEvent) -> void:
	
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	direction = direction.normalized()

	if direction.x or direction.y !=0 : 
		set_is_walking(true)
	else : 
		set_is_walking(false)
	
	if state == STATE.IDLE :
		
		if (Input.is_action_just_pressed ("melee_attack") and canMelee == true) :
			canMelee = false
			Cooldown_Melee.start()
			set_state(STATE.MELEE)


		
		if !isGrab:
			if (Input.is_action_just_pressed("fire") and canShoot == true ) :
				set_state(STATE.FIRE)
				Cooldown_Shoot.start()
				canShoot = false
				
				var bullet_instance = bullet.instance()
				bullet_instance.position = Bullet_Point.get_global_position()
				bullet_instance.rotation_degrees = rotation_degrees
				bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
				get_tree().get_root().add_child(bullet_instance)
			
			if (Input.is_action_just_pressed("select") and canGrenade == true) :
				canGrenade = false
				Cooldown_Grenade.start()
				set_state(STATE.GRENADE)

#

		
	

### LOGIC ###

func _update_animation() -> void :
	
	var state_name = ""
	match (state) :
		STATE.IDLE : state_name = "Idle"
		STATE.RELOAD : state_name = "Reload"
		STATE.FIRE : state_name = "Fire"
		
		STATE.MELEE : state_name = "Melee"
		STATE.HURT : state_name = "Hurt"
		STATE.DEAD : state_name = "Dead"
		STATE.GRENADE : state_name = "Grenade"



		
	Animated_Sprite.play(state_name)
func _update_sound() -> void :
	match (state) :
		
		STATE.FIRE : Sandbox_Fire.play()
		STATE.RELOAD : Sandbox_Reload.play()
		STATE.MELEE : Sandbox_Melee.play()
		STATE.GRENADE : Sandbox_Pin_Grande.play()

func _attack_effect():
	var body_array = Melee_Hitbox.get_overlapping_bodies()
	
	for body in body_array:
		if body == self :
			continue
		
		if body.has_method("hit"):
			body.hit(meleeDamage)
func hit(damage : int):
	damage_taken = damage
	set_state(STATE.HURT)
	
func is_grab(body : Node2D) :
		body_target = body
		look_at(body.position)
		isGrab = true
		canGrab = false
		speed = 0
		body = null
		

### SIGNAL RESPONSES ###

func _on_is_walking_changed () :
	
	if walk == true : 
		Sandbox_Walk_sand.play()
	else : Sandbox_Walk_sand.stop()
func _on_Sprite_animation_finished():
	
	
	match (state) :
		
		STATE.FIRE : set_state(STATE.RELOAD)
		STATE.RELOAD : set_state(STATE.IDLE)
		STATE.GRENADE : 
			var grenade_instance = grenade.instance()
			grenade_instance.position = Grenade_Point.get_global_position()
			grenade_instance.rotation_degrees = rotation_degrees
			grenade_instance.apply_impulse(Vector2(),Vector2(grenade_speed,0).rotated(rotation))
			get_tree().get_root().add_child(grenade_instance)
			set_state(STATE.IDLE)
		
		STATE.MELEE : 
			if isGrab : 
				isGrab = false
				speed = 100
				Cooldown_CanGrab.start()
			set_state(STATE.IDLE)
			
		STATE.HURT :
			if isGrab : 
				isGrab = false
				speed = 100
				Cooldown_CanGrab.start()
			set_state(STATE.IDLE)
			
func _on_melee_frame_changed():
	if "Melee".is_subsequence_of(Animated_Sprite.get_animation()):
		if Animated_Sprite.get_frame() == 2:
			_attack_effect()
		
func _on_state_changed():
	
	_update_animation()
	_update_sound()
	
func _on_timeout_cooldown_grenade():
	canGrenade = true
func _on_timeout_cooldown_melee():
	canMelee =true
func _on_timeout_cooldown_shoot():
	canShoot = true
func _on_timeout_cooldown_canGrab():
	canGrab = true
