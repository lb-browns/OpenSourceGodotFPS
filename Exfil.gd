extends Node3D

signal CHANGESCENE



func _on_area_3d_body_entered(body):
	emit_signal("CHANGESCENE")
