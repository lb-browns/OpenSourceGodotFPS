extends CanvasLayer


@onready var CurrentWeaponStack = $VBoxContainer/HBoxContainer3/WeaponStack
@onready var CurrentAmmoLabel = $WeaponIconHolder/CurrentAmmo
@onready var CurrentWeaponLabel = $VBoxContainer/HBoxContainer/CurrentWeapon
@onready var CurrentIcon = $WeaponIconHolder/Sprite2D
@onready var CurrentEnemies = $VBoxContainer/HBoxContainer4/Label
@onready var RoomsCleared = $VBoxContainer/HBoxContainer5/Label
@onready var roomsCleared = 0
@onready var exfil = get_node("root/Node/Node/Exfil")




func _on_weapons_manager_update_ammo(Ammo):
	CurrentAmmoLabel.set_text(str(Ammo[0])+" / "+ str(Ammo[1]))

func _on_weapons_manager_update_weapon_stack(weaponStack):
	CurrentWeaponStack.set_text("")
	for i in weaponStack:
		CurrentWeaponStack.text += "\n"+i

func _on_weapons_manager_weapon_changed(weaponName, icon):
	CurrentWeaponLabel.set_text(weaponName)
	CurrentIcon.set_texture(icon)

func addRoomCleared():
	roomsCleared += 1
	RoomsCleared.set_text("Rooms Cleared: " + str(roomsCleared))
