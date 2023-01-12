extends State
class_name HurtState

func enter_state():
	if owner.has_method("_hurt_enter_state"):
		var __ = owner._hurt_enter_state()
	else : pass

func update(_delta : float):
	if owner.has_method("_hurt_update_state"):
		var __ = owner._hurt_update_state()
	else : pass
	
func exite_state():
	if owner.has_method("_hurt_exit_state"):
		var __ = owner.hurt_exit_state()
