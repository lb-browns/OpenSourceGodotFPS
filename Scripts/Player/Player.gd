extends CharacterBody3D

#VERSION 0.1.0

@export var playerHealth = 150
@onready var MainCamera = get_node("camHolder/Main Cam")
@onready var anim = get_node("PlayerAnimations")
@onready var footstepAudio = $"Player Audios/Footsteps"
@onready var wepResource = $"camHolder/Main Cam/WeaponsManager"
@onready var hpBar = $CanvasLayer/BoxContainer/Health
@onready var deathScreen = preload("res://tscn/Player/DeathScreen.tscn")
@onready var mainMenu = preload("res://tscn/World/Maps/mainMenu.tscn")
@onready var pauseMenu = $"CanvasLayer/Pause Menu"

var jumpNum


@export var SPEED = 5.0
@export var slideSpeed = 10.0
@export var sprintSpeed = 1.8
const JUMP_VELOCITY = 5

var CamRotation = Vector2(0,0)
var mouseSensitivity = 0.001
var mouseEvent : Vector2
var isPaused = false

@export var weaponHolder : Node3D
@export var weapontSwayAmount = 2.0
@export var weaponRotationAmount = 0.3
@export var camRotationAmount = 0.01
@export var difficultyTier = 1
var roomsCleared = 0 


@onready var defaultWeaponHolderPos
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	defaultWeaponHolderPos = weaponHolder.position
	
	MainCamera.current = true

func _process(delta):
	hpBar.value = playerHealth
	
	if playerHealth <= 0:
		Die()

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		if isPaused:
			unPause()
		elif !isPaused:
			pause()
	if event is InputEventMouseMotion:
		mouseEvent = event.relative * mouseSensitivity
		CameraLook(mouseEvent)


func CameraLook(Movement: Vector2):
	if !isPaused:
		CamRotation += Movement
		CamRotation.y = clamp(CamRotation.y, -1.5,1.2)
		
		transform.basis = Basis()
		MainCamera.transform.basis = Basis()
		
		rotate_object_local(Vector3(0,1,0), -CamRotation.x) # Rotate y First!!
		MainCamera.rotate_object_local(Vector3(1,0,0), -CamRotation.y)

func _physics_process(delta):
	if !isPaused:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		#handle sprint
		if Input.is_action_just_pressed("Sprint"):
			SPEED *= sprintSpeed
		if Input.is_action_just_released("Sprint"):
			SPEED = 5.0
		
		# Handle jump.
		if is_on_floor():
			jumpNum = 0
		if Input.is_action_just_pressed("Jump") and jumpNum < 2:
			jumpNum += 1
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		if is_on_floor() && velocity.length() > 0:
			playFootstepAudio()
		
		if Input.is_action_just_pressed("Crouch"):
			anim.play("Slide")
			
		if Input.is_action_just_pressed("Crouch") and is_on_floor():
			SPEED += slideSpeed
			
		
		if Input.is_action_just_released("Crouch"):
			anim.play("RESET")
			SPEED = 5.0
		
		weaponSway(delta)
		move_and_slide()
		camTilt(input_dir.x, delta)
		weaponTilt(input_dir.x, delta)
		weaponBob(velocity.length(),delta)

func camTilt(input_x, delta):
	if MainCamera:
		MainCamera.rotation.z = lerp(MainCamera.rotation.z, -input_x * camRotationAmount, 10 * delta)

func weaponTilt(input_x, delta):
	if weaponHolder:
		weaponHolder.rotation.z = lerp(weaponHolder.rotation.z, -input_x * weaponRotationAmount, 10 * delta)
		
func weaponSway(delta):
	mouseEvent = lerp(mouseEvent, Vector2.ZERO, 10 *delta)
	weaponHolder.rotation.x = lerp(weaponHolder.rotation.x, mouseEvent.y * weapontSwayAmount, 10 * delta)
	weaponHolder.rotation.y = lerp(weaponHolder.rotation.y, mouseEvent.x * weapontSwayAmount, 10 * delta)
func weaponBob(vel : float, delta):
	if weaponHolder:
		if vel > 0:
			var bobAmount = 0.01
			var bobFreq = 0.01
			weaponHolder.position.x = lerp(weaponHolder.position.x, defaultWeaponHolderPos.x + sin(Time.get_ticks_msec() * bobFreq) * bobAmount, 10 * delta)
			weaponHolder.position.y = lerp(weaponHolder.position.y, defaultWeaponHolderPos.y + sin(Time.get_ticks_msec() * bobFreq * 0.5) * bobAmount, 10 * delta)
		else:
			weaponHolder.position.x = lerp(weaponHolder.position.x, defaultWeaponHolderPos.x, 10 * delta)
			weaponHolder.position.y = lerp(weaponHolder.position.y, defaultWeaponHolderPos.y, 10 * delta)

func Die():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_packed(deathScreen)
	


func _on_area_3d_body_entered(body):
	playerHealth -= 999
	print("oioioi")

func playFootstepAudio():
	if !footstepAudio.playing:
		footstepAudio.pitch_scale = randf_range(0.8, 1.2)
		footstepAudio.play()
@rpc("any_peer")
func receiveDamage():
	var takenDamage = wepResource.currentWeapon.weaponDamage
	playerHealth -= takenDamage

func _on_resume_pressed():
	unPause()


func pause():
	isPaused = true
	pauseMenu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func unPause():
	isPaused = false
	pauseMenu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




func _on_quit_pressed():
	get_tree().change_scene_to_packed(mainMenu)





