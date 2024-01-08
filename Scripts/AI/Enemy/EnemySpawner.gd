extends Node3D

@export var spawnLimit = 15
@export var Enemies = [
	preload("res://tscn/Enemy/enemyDev.tscn"),
	preload("res://tscn/Enemy/enemyDev2.tscn"),
	preload("res://tscn/Enemy/enemyDev3.tscn")
]

var enemies
var newEnemy
var canSpawn


func spawnEnemy():
	
	randomize()
	var x = randi() % Enemies.size()
	
	enemies = Enemies[x]
	newEnemy = enemies.instantiate()
	
	add_child(newEnemy)
	spawnLimit -= 1
	
	


func _on_timer_timeout():
	if spawnLimit > 0:
		spawnEnemy()
		Timer
