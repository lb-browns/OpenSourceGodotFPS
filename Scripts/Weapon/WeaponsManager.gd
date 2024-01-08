extends Node3D

signal weaponChanged
signal updateAmmo
signal updateWeaponStack

@onready var player = $"../../.."
@onready var animPlayer = get_node("../../../AnimationPlayer") 
@onready var bulletPoint = get_node("%bulletPoint")

var raycastDebug = preload("res://tscn/Weapons/Misc/raycastDebug.tscn")

var currentWeapon = null

var weaponStack = []

#var weaponIndicator = 0

var nextWeapon: String

var weaponList = {}

@export var _weaponResources: Array[weaponResource]

@export var startWeapons: Array[String]

enum {NULL, HITSCAN, PROJECTILE}

func _ready():
	Initialize(startWeapons) #enter state-machine


func Initialize(_startWeapons: Array):
	for weapon in _weaponResources:
		weaponList[weapon.weaponName] = weapon
	
	for i in _startWeapons:
		weaponStack.push_back(i) #add out start weapons
	currentWeapon = weaponList[weaponStack[0]]
	emit_signal("updateWeaponStack", weaponStack)
	enter()
	

func _input(event):
	if not is_multiplayer_authority(): return
	if event.is_action_pressed("weaponUP"):
		var getref = weaponStack.find(currentWeapon.weaponName)
		getref = min(getref+1, weaponStack.size()-1)
		exit(weaponStack[getref])
	
	if event.is_action_pressed("WeaponDown"):
		var getref = weaponStack.find(currentWeapon.weaponName)
		getref = max(getref-1, 0)
		exit(weaponStack[getref])
	
	if event.is_action_pressed("Shoot"):
		Shoot.rpc()
	
	if event.is_action_pressed("Reload"):
		Reload()
	if event.is_action_pressed("Drop"):
		Drop(currentWeapon.weaponName)



func enter():
	
	animPlayer.queue(currentWeapon.activateAnim)
	emit_signal("weaponChanged", currentWeapon.weaponName, currentWeapon.icon)
	emit_signal("updateAmmo",[currentWeapon.currAmmo, currentWeapon.reserveAmmo])
	

func exit(_nextWeapon: String):
	#call exit before weapon change
	if _nextWeapon != currentWeapon.weaponName:
		if animPlayer.get_current_animation() != currentWeapon.deactivateAnim:
			animPlayer.play(currentWeapon.deactivateAnim)
			nextWeapon = _nextWeapon
	
		

func changeWeapon(weaponName: String):
	currentWeapon = weaponList[weaponName]
	nextWeapon = ""
	enter()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == currentWeapon.deactivateAnim:
		changeWeapon(nextWeapon)
	if anim_name == currentWeapon.fireAnim && currentWeapon.Automatic == true:
		if Input.is_action_pressed("Shoot"):
			Shoot.rpc()

@rpc("call_local")
func Shoot():
	if currentWeapon.Melee:
		if !animPlayer.is_playing():
				animPlayer.play(currentWeapon.fireAnim)
				var cameraCollision = getCameraCollision()
				match currentWeapon.Type:
					NULL:
						print("no type selected")
					HITSCAN:
						hitscanCol(cameraCollision)
					PROJECTILE:
						launchProjectile(cameraCollision)
	if currentWeapon.currAmmo != 0:
		if !animPlayer.is_playing():
				animPlayer.play(currentWeapon.fireAnim)
				currentWeapon.currAmmo -= 1
				emit_signal("updateAmmo",[currentWeapon.currAmmo, currentWeapon.reserveAmmo])
				var cameraCollision = getCameraCollision()
				match currentWeapon.Type:
					NULL:
						print("no type selected")
					HITSCAN:
						hitscanCol(cameraCollision)
					PROJECTILE:
						launchProjectile(cameraCollision)
		if !animPlayer.is_playing():
			animPlayer.play(currentWeapon.fireAnim)
			currentWeapon.currAmmo -= 1
			emit_signal("updateAmmo",[currentWeapon.currAmmo, currentWeapon.reserveAmmo])
			var cameraCollision = getCameraCollision()
			match currentWeapon.Type:
				NULL:
					print("no type selected")
				HITSCAN:
					hitscanCol(cameraCollision)
				PROJECTILE:
					launchProjectile(cameraCollision)
			
		else:
			Reload()

func Reload():
	if currentWeapon.currAmmo == currentWeapon.Mag:
		return
	elif !animPlayer.is_playing():
		if currentWeapon.reserveAmmo != 0:
			animPlayer.play(currentWeapon.reloadAnim)
			var reloadAmount = min(currentWeapon.Mag - currentWeapon.currAmmo, currentWeapon.Mag, currentWeapon.reserveAmmo)
			currentWeapon.currAmmo = currentWeapon.currAmmo + reloadAmount
			currentWeapon.reserveAmmo = currentWeapon.reserveAmmo - reloadAmount
			emit_signal("updateAmmo",[currentWeapon.currAmmo, currentWeapon.reserveAmmo])
	

func getCameraCollision()->Vector3:
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	
	var rayOrigin = camera.project_ray_origin(viewport/2)
	var rayEnd = rayOrigin + camera.project_ray_normal(viewport/2) * currentWeapon.weaponRange
	
	var newIntersection = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	var Intersection = get_world_3d().direct_space_state.intersect_ray(newIntersection)
	
	if not Intersection.is_empty():
		var collisionPoint = Intersection.position
		return collisionPoint
	else:
		return rayEnd
@rpc("call_local")
func hitscanCol(collisionPoint):
	print("BOOM")
	var bulletDirection = (collisionPoint - bulletPoint.get_global_transform().origin).normalized()
	var newIntersection = PhysicsRayQueryParameters3D.create(bulletPoint.get_global_transform().origin, collisionPoint + bulletDirection * 2)
	
	var bulletCollision = get_world_3d().direct_space_state.intersect_ray(newIntersection)
	print("BOOM 2")
	if bulletCollision:
		var hitIndicator = raycastDebug.instantiate()
		var world = get_tree().get_root().get_child(0)
		
		world.add_child(hitIndicator)
		hitIndicator.global_translate(bulletCollision.position)
		
		hitscanDamage(bulletCollision.collider, bulletDirection, bulletCollision.position)
		print("BOOM 3")


func hitscanDamage(Collider, Direction, Position):
	print(Collider)
	if Collider.is_in_group("Target"):
		print("BOOM 5")
		Collider.hitSuccessful(currentWeapon.weaponDamage, Direction, Position)
	elif Collider.is_in_group("Player"):
		print(Collider.playerHealth)
		player.receiveDamage.rpc_id(Collider.get_multiplayer_authority())
		#Collider.hitSuccessful(currentWeapon.weaponDamage, Direction, Position)
	elif Collider.is_in_group("Enemy"):
		Collider.takeDamage(currentWeapon.weaponDamage)

func launchProjectile(Point):
	var Direction = (Point - bulletPoint.get_global_transform().origin).normalized()
	var Projectile = currentWeapon.projectileToLoad.instantiate()
	bulletPoint.add_child(Projectile)
	Projectile.Damage = currentWeapon.weaponDamage
	Projectile.set_linear_velocity(Direction * currentWeapon.projectileVelocity)


func _on_pickup_detection_body_entered(body):
	if body.pickupReady:
		var weaponInStack = weaponStack.find(body.weaponName,0)
		print("entered")
	
		if weaponInStack == -1 && body.pickUpType == "Weapon": #pickup weapon
			var getref = weaponStack.find(currentWeapon.weaponName)
			weaponStack.insert(getref,body.weaponName)
		
			print("if went true")
		#zero out ammo in resource
			weaponList[body.weaponName].currAmmo = body.CurrAmmo
			weaponList[body.weaponName].reserveAmmo = body.ReserveAmmo
		
			emit_signal("updateWeaponStack", weaponStack)
			exit(body.weaponName)
			body.queue_free()
		else:
			var Remaining = addAmmo(body.weaponName, body.CurrAmmo+body.ReserveAmmo)
			if Remaining == 0:
				body.queue_free()
			
			body.CurrAmmo = 0
			body.ReserveAmmo = Remaining

func Drop(_name:String):
	if weaponList[_name].Droppable:
		var weaponRef = weaponStack.find(_name,0)
		
		if weaponRef != -1:
			weaponStack.pop_at(weaponRef)
			emit_signal("updateWeaponStack", weaponStack)
			
			var weaponDropped = weaponList[_name].weaponDrop.instantiate()
			weaponDropped.CurrAmmo = weaponList[_name].currAmmo
			weaponDropped.ReserveAmmo = weaponList[_name].reserveAmmo
			
			weaponDropped.set_transform(bulletPoint.get_global_transform())
			var World = get_tree().get_root().get_child(0)
			World.add_child(weaponDropped)
			
			var getref = weaponStack.find(currentWeapon.weaponName)
			getref = max(-1,0)
			exit(weaponStack[getref])

func addAmmo(_Weapon: String, ammo: int)->int:
	var _weapon = weaponList[_Weapon]
	
	var required = _weapon.maxAmmo - _weapon.reserveAmmo
	var remaining = max(ammo - required, 0)
	
	_weapon.currAmmo += min(ammo, required)
	emit_signal("updateAmmo",[currentWeapon.currAmmo, currentWeapon.reserveAmmo])
	
	return remaining
	
	



