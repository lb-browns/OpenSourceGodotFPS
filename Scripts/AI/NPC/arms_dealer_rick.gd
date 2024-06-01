extends Node3D

@export var NAME = "Arms Dealer Ricky"
@export var HEALTH = 100.0
@export var DIALOG = "text_not_set"
@export var Inventory = [preload("res://tscn/Weapons/Pickups/DBshottyPickup.tscn")]
@export var itemPrice = 5000
@onready var wherePutItem = $item
@onready var buySound = $"../Register"
@onready var buySound2 = $"../Speech"
@onready var paymentDeclinedSFX = $"../payment declined"
@onready var animPlayer = $CollisionShape3D/ArmsDealerRick/AnimationPlayer
var force = Vector3(0, 5, -500)
var interactKey


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setDialog()

func _input(event):
	pass

func buyItem():
	var itemToGive
	var item
	itemToGive = Inventory[randi() % Inventory.size()]
	animPlayer.play("paymentAccepted")
	item = itemToGive.instantiate()
	wherePutItem.add_child(item)
	add_child(item)
	item.apply_central_force(force)
	
	buySound.play()
	buySound2.play()
	

func getInteractKey():
	var actionEvents = InputMap.action_get_events("Interact")[0]
	var keyCode = actionEvents.physical_keycode
	interactKey = OS.get_keycode_string(keyCode)

func setDialog():
	getInteractKey()
	DIALOG = "[" + interactKey + "]" + " Purchase Firearm For ₽" + str(itemPrice)
	

func paymentDeclined():
	animPlayer.play("paymentDeclined")
	paymentDeclinedSFX.play()
	
