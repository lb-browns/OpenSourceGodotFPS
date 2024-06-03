extends StaticBody3D

@export var HealAmount = 25
@export var MaxHealthAmount = 50
@export var SpeedAmount = 0.2
@export var DamageAmount = 3
@export var DIALOG = "Dialog Not Set"
@export var tablePrice = 2500
@export var tableText = "default"
@onready var interactKey
@onready var pay = $AudioStreamPlayer3D



# Called when the node enters the scene tree for the first time.
func _ready():
	getInteractKey()
	setDialog()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getInteractKey():
	var actionEvents = InputMap.action_get_events("Interact")[0]
	var keyCode = actionEvents.physical_keycode
	interactKey = OS.get_keycode_string(keyCode)

func setDialog():
	getInteractKey()
	DIALOG = "[" + interactKey + "] " + tableText + " For ₽" + str(tablePrice)
	

func paymentSuccess():
	pay.play()
