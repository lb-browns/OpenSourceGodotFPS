extends Resource

class_name weaponResource

@export var weaponName: String

@export var activateAnim: String
@export var deactivateAnim: String
@export var fireAnim: String
@export var reloadAnim: String
@export var icon: Texture

@export var currAmmo: int
@export var reserveAmmo: int
@export var Mag: int
@export var maxAmmo: int

@export var Automatic: bool
@export var weaponRange : int
@export var weaponDamage : int
@export_flags("HitScan", "Projectile") var Type
@export var projectileToLoad: PackedScene
@export var weaponDrop: PackedScene
@export var projectileVelocity: int
@export var Droppable: bool
@export var Melee: bool


