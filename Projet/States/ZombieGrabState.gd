extends State

func enter_state():
	if owner.has_method("_grab_enter_state") :
		var __ = owner._grab_enter_state()
	else : pass

func update (_delta : float):
	if owner.has_method("_grab_update_state"):
		var __ = owner._grab_update_state()
	else : pass

func exit_state():
	if owner.has_method("_grab_exit_state"):
		var __ = owner._grab_exit_state
	else : pass
