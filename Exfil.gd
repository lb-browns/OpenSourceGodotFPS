extends Node3D

signal CHANGESCENE

@onready var player = get_tree().get_root().get_node("Node/Player")
@onready var playerGUI = get_tree().get_root().get_node("Node/Player/CanvasLayer")

func _on_area_3d_body_entered(body):
	emit_signal("CHANGESCENE")
	player.difficultyTier += 0.1
	playerGUI.addRoomCleared()
	queue_free()
	
