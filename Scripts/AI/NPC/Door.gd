extends StaticBody3D
var DIALOG
var interactKey
@export var travelPrice = 25000
@export var locationName = "Rickys Secret Stash"
var Location = Vector3(0, 0, 0)
@export var nodeHolder = Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	getInteractKey()
	setDialog()
	Location = nodeHolder.transform
	print(nodeHolder.transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getInteractKey():
	var actionEvents = InputMap.action_get_events("Interact")[0]
	var keyCode = actionEvents.physical_keycode
	interactKey = OS.get_keycode_string(keyCode)

func setDialog():
	getInteractKey()
	DIALOG = "[" + interactKey + "]" + " Unlock " + locationName + " For ₽" + str(travelPrice)
	
