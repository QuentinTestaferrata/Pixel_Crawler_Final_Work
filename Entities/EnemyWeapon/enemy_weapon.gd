extends Resource
class_name EnemyWeaponData

enum weapon_types {STAFF, WAND, SHIELD, SWORD, DAGGER}

@export_category("Weapon Data")
@export var weapon_name: String
@export var scene: PackedScene
@export var sprite: Texture

@export_category("Weapon Stats")
@export var weapon_type: weapon_types
@export var damage: int
@export var knockback_force: float
@export var defense: int = 0
