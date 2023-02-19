extends State
class_name DrawState

func enter_state():
	if owner.has_method("_draw_enter_state"):
		var __ = owner._draw_enter_state()
	else : pass
	
func update(_delta : float):
	if owner.has_method("_draw_update_state"):
		var __ = owner._draw_update_state()
	else : pass
	
func exit_state():
	if owner.has_method("_draw_exit_state"):
		var __ = owner._draw_exit_state()
	else : pass
