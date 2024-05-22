extends CharacterBody3D

@export var SPEED = 4.0
@export var ATTACK_RANGE = 1.3
@export var DAMAGE = 0.2
@export var HEALTH = 75.0

@onready var canSeePlayer = false

var stateMachine

@onready var player = get_tree().get_root().get_node("Node/Player")

@onready var wanderPath = Vector3(randi() % 10, randi() % 10, 0) 

@onready var playerPath = null

@onready var navAgent = $NavigationAgent3D
@onready var animTree = $AnimationTree

signal enemyKilled

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED *= player.difficultyTier
	DAMAGE *= player.difficultyTier
	HEALTH *= player.difficultyTier
	stateMachine = animTree.get("parameters/playback")

func _on_timer_timeout():
	var x = randf_range(-100, 100)
	var y = randf_range(100, -100)
	var z = randf_range(100, -100)
	wanderPath = Vector3(x, y, z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	
	if HEALTH <= 0:
		Die()
	if canSeePlayer:
		match stateMachine.get_current_node():
			"Tracking":
				#nav
				navAgent.set_target_position(player.global_position)
				var nextNavPoint = navAgent.get_next_path_position()
				velocity = (nextNavPoint - global_transform.origin).normalized() * SPEED
				look_at(Vector3(player.global_position.x + velocity.x, global_position.y, player.global_position.z + velocity.z,), Vector3.UP)
				print("Tracking")
			"Attacking":
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z,), Vector3.UP)
				hitPlayer()
				print("Attacking")
	else:
		navAgent.set_target_position(wanderPath)
		var nextNavPoint = navAgent.get_next_path_position()
		velocity = (nextNavPoint - global_transform.origin).normalized() * SPEED
		print("Wandering")
		print(str(wanderPath))
	
	#conditions
	animTree.set("parameters/conditions/isAttacking", targetInRange())
	animTree.set("parameters/conditions/Run", !targetInRange())
	
	move_and_slide()

func targetInRange():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func hitPlayer():
	player.playerHealth -= DAMAGE

func takeDamage(weaponDamage):
	print(HEALTH)
	HEALTH -= weaponDamage

func Die():
	emit_signal("enemyKilled")
	queue_free()

func _on_area_3d_body_entered(body):
	print(str(body) + "- from enemy")
	if body.is_in_group("Player"):
		canSeePlayer = true
		print("AI SPOTTED PLAYER")

func _on_area_3d_body_exited(body):
	print(str(body) + "- from enemy")
	if body.is_in_group("Player"):
		canSeePlayer = false
		print("AI LOST PLAYER")
