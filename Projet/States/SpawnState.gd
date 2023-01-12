extends State
class_name SpawnState

func enter_state():
	if owner.has_method("_spawn_enter_state"):
		var __ = owner._spawn_enter_state()
		__ = owner._update_animation()
		__ = owner._update_sound()
		
	else : pass


func update(_delta: float):
	if owner.has_method("_spawn_update_state"):
		var __ = owner._spawn_update_state()
	else : pass


func exit_state():
	if owner.has_method("_spawn_exit_state"):
		var __ = owner._spawn_exit_state()
	else : pass
	
