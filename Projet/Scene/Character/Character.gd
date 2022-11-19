extends KinematicBody2D

onready var Sprite_character = get_node("Sprite_character")

var bullet = preload("res://Scene/Character/bullet.tscn")

export var bullet_speed = 1000

var speed = 100
var direction = Vector2.ZERO
var canShoot = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func _process(delta : float) -> void:
	
	move_and_slide(direction * speed)
	look_at(get_global_mouse_position())
	
func _input(event:InputEvent) -> void:
	
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	direction = direction.normalized()
	
	if (Input.is_action_just_pressed("fire") and canShoot == true)  :
		
		var bullet_instance = bullet.instance()
		bullet_instance.position = $bullet_point.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		Sprite_character.play("fire_reload")
		canShoot = false
		


func _on_Sprite_character_animation_finished():
	
	if "fire_reload".is_subsequence_of(Sprite_character.get_animation()) :
		canShoot = true
		Sprite_character.play("default")
