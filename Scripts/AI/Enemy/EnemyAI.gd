extends CharacterBody3D

const SPEED = 4.0
const ATTACK_RANGE = 1.0
const DAMAGE = 0.2
var HEALTH = 75.0

var stateMachine

@onready var player = get_tree().get_root().get_node("Node/Player")

@onready var playerPath = null

@onready var navAgent = $NavigationAgent3D
@onready var animTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine = animTree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	
	if HEALTH <= 0:
		Die()
	
	match stateMachine.get_current_node():
		"Tracking":
			#nav
			navAgent.set_target_position(player.global_position)
			var nextNavPoint = navAgent.get_next_path_position()
			velocity = (nextNavPoint - global_transform.origin).normalized() * SPEED
			look_at(Vector3(player.global_position.x + velocity.x, global_position.y, player.global_position.z + velocity.z,), Vector3.UP)
		"Attacking":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z,), Vector3.UP)
			hitPlayer()
	
	
	#conditions
	animTree.set("parameters/conditions/isAttacking", targetInRange())
	animTree.set("parameters/conditions/Run", !targetInRange())
	
	move_and_slide()

func targetInRange():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func hitPlayer():
	player.playerHealth -= DAMAGE

func takeDamage(damageAmnt):
	print(HEALTH)
	HEALTH -= damageAmnt

func Die():
	queue_free()
