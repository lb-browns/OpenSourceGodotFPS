extends Node3D



@export var spawnLimit = 15
@export var Enemies = [
	preload("res://tscn/Enemy/enemyDev.tscn"),
	preload("res://tscn/Enemy/enemyDev2.tscn"),
	preload("res://tscn/Enemy/enemyDev3.tscn")
]
var canExfil
var enemies
var newEnemy
@export var canSpawn = true


signal ActivateExfil

func _ready():
	spawnEnemy()
	
	

func spawnEnemy():
	
	randomize()
	var x = randi() % Enemies.size()
	
	enemies = Enemies[x]
	newEnemy = enemies.instantiate()
	
	add_child(newEnemy)
	spawnLimit -= 1
	
	



func _on_timer_timeout():
	if spawnLimit > 0 && canSpawn:
		canExfil = false
		spawnEnemy()
		Timer
	elif get_tree().get_nodes_in_group("Enemy").size() <= 0 && spawnLimit <= 0:
		emit_signal("ActivateExfil")
