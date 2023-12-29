extends CanvasLayer


@onready var CurrentWeaponStack = $VBoxContainer/HBoxContainer3/WeaponStack
@onready var CurrentAmmoLabel = $WeaponIconHolder/CurrentAmmo
@onready var CurrentWeaponLabel = $VBoxContainer/HBoxContainer/CurrentWeapon
@onready var CurrentIcon = $WeaponIconHolder/Sprite2D


func _on_weapons_manager_update_ammo(Ammo):
	CurrentAmmoLabel.set_text(str(Ammo[0])+" / "+ str(Ammo[1]))



func _on_weapons_manager_update_weapon_stack(weaponStack):
	CurrentWeaponStack.set_text("")
	for i in weaponStack:
		CurrentWeaponStack.text += "\n"+i


func _on_weapons_manager_weapon_changed(weaponName, icon):
	CurrentWeaponLabel.set_text(weaponName)
	CurrentIcon.set_texture(icon)
