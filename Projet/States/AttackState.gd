extends State
class_name AttackState

func enter_state():
	if owner.has_method("_attack_enter_state"):
		var __ = owner._attack_enter_state()
	else : pass
	
func update(_delta : float):
	if owner.has_method("_attack_update_state"):
		var __ = owner._attack_update_state()
	else : pass
	
func exit_state():
	if owner.has_method("_attack_exit_state"):
		var __ = owner._attack_exit_statre()
	else : pass
