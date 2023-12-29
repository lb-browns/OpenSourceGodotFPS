extends RigidBody3D

var Damage: int = 0


func _on_body_entered(body):
	if body.is_in_group("Target") && body.has_method("hitSuccessful"):
		body.hitSuccessful(Damage)
		queue_free()
		
	


func _on_timer_timeout():
	queue_free()
