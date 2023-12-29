extends RigidBody3D

@export var weaponName: String
@export var CurrAmmo: int
@export var ReserveAmmo: int

@export_enum("Weapon", "Ammo") var pickUpType: String = "Weapon"

var pickupReady = false

func _ready():
	await get_tree().create_timer(2.0).timeout
	pickupReady = true
