extends RigidBody3D

var Health = 50

func hitSuccessful(Damage):
	Health -= Damage
	
	print("gang " + str(Health))
	
	if Health <= 0:
		queue_free()
