extends State
class_name IdleState

func enter_state():
	if owner.has_method("_idle_enter_state"):
		var __ = owner._idle_enter_state()
	else : pass
	
func update(_delta : float):
	if owner.has_method("_idle_update_state"):
		var __ = owner._idle_update_state()
	else : pass
	
func exit_state():
	if owner.has_method("_idle_exit_state"):
		var __ = owner._idle_exit_state()
	else : pass
