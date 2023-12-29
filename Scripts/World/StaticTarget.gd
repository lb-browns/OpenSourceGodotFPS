extends StaticBody3D

var Health = 1

func hitSuccessful(weaponDamage, _Direction: = Vector3.ZERO, _Position: = Vector3.ZERO):
	Health -= weaponDamage
	if Health <= 0:
		queue_free()
