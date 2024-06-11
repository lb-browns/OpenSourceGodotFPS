extends CharacterBody3D

@export var SPEED = 4.0
@export var ATTACK_RANGE = 1.4
@export var DAMAGE = 1.5
@export var HEALTH = 75.0
@export var MAX_HEALTH = 75.0
@export var NAME = "RICKY"
@export var isLegendary = false
@export var isBoss = false

@onready var canSeePlayer = false
@onready var inAttackRange

var stateMachine

@onready var player = get_tree().get_root().get_node("Node/Player")

@onready var wanderPath = Vector3(randi() % 10, randi() % 10, 0) 

@onready var playerPath = null

@onready var SELF = $"."


@onready var navAgent = $NavigationAgent3D
@onready var animTree = $AnimationTree
@onready var animPlayer = $CollisionShape3D/aaaa/AnimationPlayer

signal enemyKilled

# Called when the node enters the scene tree for the first time.
func _ready():
	
	DAMAGE *= player.difficultyTier
	MAX_HEALTH *= player.difficultyTier
	chooseRandName()
	randRarity()
	setLegendary()
	HEALTH = MAX_HEALTH
	stateMachine = animTree.get("parameters/playback")
	
	SELF.apply_floor_snap()
	

func _on_timer_timeout():
	var x = randf_range(-999, 999)
	var y = randf_range(999, -999)
	var z = randf_range(999, -999)
	wanderPath = Vector3(x, y, z)
	if inAttackRange && animPlayer.current_animation_position == 0.0:
		hitPlayer()

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
				inAttackRange = false
			"Attacking":
				inAttackRange = true
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z,), Vector3.UP)
				print(str(DAMAGE))
	else:
		navAgent.set_target_position(wanderPath)
		var nextNavPoint = navAgent.get_next_path_position()
		velocity = (nextNavPoint - global_transform.origin).normalized() * SPEED
		inAttackRange = false
	#conditions
	animTree.set("parameters/conditions/isAttacking", targetInRange())
	animTree.set("parameters/conditions/Run", !targetInRange())
	
	move_and_slide()

func targetInRange():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func hitPlayer():
	SELF.apply_floor_snap()
	player.playerHealth -= DAMAGE
	player.playerDamageAudio.pitch_scale = randf_range(1.9, 2.6)
	player.playerDamageAudio.play()
	player.anim.play("Take Damage")

func takeDamage(weaponDamage):
	print(HEALTH)
	HEALTH -= weaponDamage

func Die():
	emit_signal("enemyKilled")
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		canSeePlayer = true
		print("AI SPOTTED PLAYER")

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		canSeePlayer = false
		print("AI LOST PLAYER")

func chooseRandName():
	var nameArray = ["Joe", "Bob", "Rick", "Dave", "Aleksandr", "Dmitri", "Dominik", "Ivan", "Fyodor", "Igor"]
	var titleArray = [", From California", ", The Crack Head", ", Daves Friend", ", Ivans Cousin", ", The Gay One", "","","","","","",""]
	var title1Array = ["Stinky ", "Fat ", "Skinny ", "Big ", "Little ", "", "", "", "", "", ""]
	NAME = str(title1Array[randi() % title1Array.size()]) + str(nameArray[randi() % nameArray.size()]) + str(titleArray[randi() % titleArray.size()])

func randRarity():
	var chance = randi_range(0, 25)
	if chance == 5:
		isLegendary = true 

func setLegendary():
	if isLegendary:
		MAX_HEALTH *= 3
		DAMAGE *= 3
		NAME = "Legendary " + NAME
