extends Node3D

@export var spawnLimit = 15
@export var Enemies = [
	preload("res://tscn/Enemy/enemyDev.tscn"),
	preload("res://tscn/Enemy/enemyDev2.tscn"),
	preload("res://tscn/Enemy/enemyDev3.tscn")
]

var enemies
var newEnemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	randomize()
	var x = randi() % Enemies.size()
	
	enemies = Enemies[x]
	newEnemy = enemies.instantiate()
	if spawnLimit > 0:
		spawnEnemy()

func spawnEnemy():
	await get_tree().create_timer(0.5)
	add_child(newEnemy)
	spawnLimit -= 1
