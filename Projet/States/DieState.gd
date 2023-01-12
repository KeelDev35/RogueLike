extends State
class_name DieState

func enter_state():
	if owner.has_method("_die_enter_state"):
		owner.call_deferred("_die_enter_state")
	else : pass

func update(_delta : float):
	if owner.has_method("_die_update_state"):
		var __ = owner._die_update_state()
	else : pass
	
func exit_state():
	if owner.has_method("_die_exit_state"):
		var __ = owner._die_exit_state()
	else : pass
