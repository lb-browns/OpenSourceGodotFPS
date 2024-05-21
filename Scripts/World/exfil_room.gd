extends Node3D

@onready var exfil = get_node("Node/Exfil")
@export var enemySpawnerRef : Node3D
var i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	enemySpawnerRef.ActivateExfil.connect(openDoor)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func openDoor():
	$AnimationPlayer.play("Door Open")
