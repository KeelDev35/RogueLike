extends State
class_name MoveState

func enter_state():
	if owner.has_method("_move_enter_state"):
		var __ = owner._move_enter_state()
	else : pass

func update(_delta : float):
	if owner.has_method("_move_update_state"):
		var __ = owner._move_update_state(owner.speed)
	else : pass

func exit_state():
	if owner.has_method("_move_exit_state"):
		var __ = owner._move_exit_state()
	else : pass
