extends State
class_name StateMachine


var current_state : Node = null setget set_state, get_state

var previous_state : Node = null setget , get_previous_state

signal state_changed(state)

   ### ACCESSORS ###

func set_state(state) -> void :
	if state is String:
		state = get_node_or_null(state)
	
	elif state == current_state:
		return
	
	if current_state != null:
		current_state.exit_state()
	
	previous_state = current_state
	current_state = state
	
	if current_state != null:
		current_state.enter_state() 
	
	emit_signal("state_changed", current_state)

func get_state () -> Node: return current_state
func get_state_name() -> String : 
	if current_state == null:
		return ""
	return current_state.name

func get_previous_state() -> Node: 
	return previous_state


   ### BUILT-IN ###
#func _ready():
#	set_to_default_state()

func _physics_process(delta : float) -> void:
	if current_state != null:
		current_state.update(delta)

### VIRTUAL ###

func enter_state():
#	set_to_default_state()
	pass

func exit_state():
	set_state(null)
	
#func set_to_default_state():
#	set_state(get_child(0))
