extends RigidBody3D

@export var Health = 50

@export var itemsToSpawn = [preload("res://tscn/Weapons/Pickups/emptyPickup.tscn"), preload("res://tscn/Weapons/Pickups/emptyPickup.tscn"), preload("res://tscn/Weapons/Pickups/emptyPickup.tscn"),
							preload("res://tscn/Weapons/Pickups/1911Pickup.tscn"), preload("res://tscn/Weapons/Pickups/DBshottyAmmoPickup.tscn"),
						   preload("res://tscn/Weapons/Pickups/DBshottyPickup.tscn"), preload("res://tscn/Weapons/Pickups/m_14_pickup.tscn"),
							preload("res://tscn/Weapons/Pickups/ScrewdriverPickup.tscn"), preload("res://tscn/Weapons/Pickups/emptyPickup.tscn")]
@onready var mesh = $CollisionShape3D
@onready var itemSpawnNode = get_node("ItemSpawn")
var item
var newItem

func hitSuccessful(weaponDamage, _Direction: = Vector3.ZERO, _Position: = Vector3.ZERO):
	
	var hitPosition = _Position - get_global_transform().origin
	
	Health -= weaponDamage
	
	print("gang " + str(Health))
	
	if Health <= 0:
		spawnItem()
		queue_free()
		
	
	if _Direction != Vector3.ZERO:
		apply_impulse((_Direction * weaponDamage), hitPosition)

func spawnItem():
	randomize()
	var x = randi() % itemsToSpawn.size()
	
	item = itemsToSpawn[x]
	newItem = item.instantiate()
	get_tree().get_root().add_child(newItem)
	newItem.position = itemSpawnNode.global_position
