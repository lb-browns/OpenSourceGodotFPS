extends RigidBody3D

var Health = 300

func hitSuccessful(weaponDamage, _Direction: = Vector3.ZERO, _Position: = Vector3.ZERO):
	
	var hitPosition = _Position - get_global_transform().origin
	
	Health -= weaponDamage
	
	print("gang " + str(Health))
	
	if Health <= 0:
		queue_free()
		
	
	if _Direction != Vector3.ZERO:
		apply_impulse((_Direction * weaponDamage), hitPosition)
