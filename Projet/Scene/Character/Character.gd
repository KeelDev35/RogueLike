
#############
# CHARACTER #
#############

### EXPANSION ###

extends KinematicBody2D

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

onready var Sprite_character = get_node("Sprite_character")
onready var Sandbox_Fire = get_node("SoundBox/Fire")
onready var Sandbox_Walk_sand = get_node("SoundBox/walk_sand")
onready var Sandbox_Reload = get_node("SoundBox/Reload")
onready var Sandbox_Melee = get_node("SoundBox/Melee")
onready	var	Sandbox_Pin_Grande = get_node("SoundBox/Pin_Grenade")
onready var CooldownGrenade = get_node("Cooldown_Grenade")


export var bullet_speed = 1000
export var grenade_speed = 200

var state : int = STATE.IDLE setget set_state, get_state

var bullet = preload("res://Scene/Bullet/bullet.tscn")
var grenade = preload("res://Scene/Grenade/Grenade.tscn")


var speed = 100
var direction = Vector2.ZERO
var canShoot = true
var canMelee = true
var canGrenade = true

var walk :bool setget	set_is_walking, get_is_walking

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

	var __ = connect("is_walking_changed", self, "on_is_walking_changed")
	__ = connect ("state_changed", self, "_on_state_changed")
	__ = Sprite_character.connect ("animation_finished", self, "_on_Sprite_animation_finished")
	__ = CooldownGrenade.connect("timeout",self, "_on_timeout")

func _process(delta : float) -> void: # main process function
	look_at(get_global_mouse_position())
	move_and_slide(direction * speed)
	print(canGrenade,CooldownGrenade.time_left)
	
	
func _input(event:InputEvent) -> void:
	
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	direction = direction.normalized()

	if direction.x or direction.y !=0 : 
		set_is_walking(true)
	else : 
		set_is_walking(false)
	

	if (Input.is_action_just_pressed("fire") and canShoot == true ) :
			
			set_state(STATE.FIRE)
			canShoot = false
			
			var bullet_instance = bullet.instance()
			bullet_instance.position = $bullet_point.get_global_position()
			bullet_instance.rotation_degrees = rotation_degrees
			bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
			get_tree().get_root().add_child(bullet_instance)
			
			
	if (Input.is_action_just_pressed ("melee_attack") and canMelee == true) :
		
		set_state(STATE.MELEE)
		canMelee = false
	
	if (Input.is_action_just_pressed("select") and canGrenade == true) :
		

		set_state(STATE.GRENADE)
		canGrenade = false
		CooldownGrenade.start()

		
	

### LOGIC ###

func update_animation() -> void :
	
	var state_name = ""
	match (state) :
		STATE.IDLE : state_name = "Idle"
		STATE.RELOAD : state_name = "Reload"
		STATE.FIRE : state_name = "Fire"
		
		STATE.MELEE : state_name = "Melee"
		STATE.HURT : state_name = "Hurt"
		STATE.DEAD : state_name = "Dead"
		STATE.GRENADE : state_name = "Grenade"



		
	Sprite_character.play(state_name)
	
	
func update_sound() -> void :
	
	match (state) :
		
		STATE.FIRE : Sandbox_Fire.play()
		STATE.RELOAD : Sandbox_Reload.play()
		STATE.MELEE : Sandbox_Melee.play()
		STATE.GRENADE : Sandbox_Pin_Grande.play()

### SIGNAL RESPONSES ###

func on_is_walking_changed () :
	
	if walk == true : 
		Sandbox_Walk_sand.play()
	else : Sandbox_Walk_sand.stop()
	
	
func _on_Sprite_animation_finished():
	
	var state_name = ""
	
	match (state) :
		
		STATE.FIRE : set_state(STATE.RELOAD)
		STATE.RELOAD : set_state(STATE.IDLE)
		STATE.IDLE : 
			canShoot = true
			canMelee = true
		STATE.GRENADE : 
			var grenade_instance = grenade.instance()
			grenade_instance.position = $Grenade_Point.get_global_position()
			grenade_instance.rotation_degrees = rotation_degrees
			grenade_instance.apply_impulse(Vector2(),Vector2(grenade_speed,0).rotated(rotation))
			get_tree().get_root().add_child(grenade_instance)
			set_state(STATE.IDLE)
		
		STATE.MELEE : set_state(STATE.IDLE)
		
#		STATE.FIRE : state_name = "Fire"
#		STATE.DEAD : state_name = "Dead"
#		STATE.RELOAD : state_name = "Reload"
#		STATE.MELEE : state_name = "Melee"
#		STATE.HURT : state_name = "Hurt"
#		STATE.GRENADE : state_name = "Grenade"
		

func _on_state_changed():
	
	update_animation()
	update_sound()
	
func _on_timeout():
	canGrenade = true
