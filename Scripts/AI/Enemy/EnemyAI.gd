extends CharacterBody3D

const SPEED = 4.0

@onready var player = get_tree().get_root().get_node("Node/Player")

@onready var playerPath = null

@onready var navAgent = $NavigationAgent3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(player)
	velocity = Vector3.ZERO
	navAgent.set_target_position(player.global_position)
	var nextNavPoint = navAgent.get_next_path_position()
	velocity = (nextNavPoint - global_transform.origin).normalized() * SPEED
	move_and_slide()
