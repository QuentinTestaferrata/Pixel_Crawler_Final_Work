extends Resource
class_name WeaponData

enum weapon_types {STAFF, WAND, SHIELD, SWORD, DAGGER, BOW}
enum rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHICAL}

@export_category("Weapon Data")
@export var weapon_name: String
@export var scene: PackedScene
@export var sprite: Texture
@export var shop_sprite: Texture
@export var showcase_sprite: Texture = null
@export var price: int
@export var obtained: bool = false
@export var equip_slot: int = 0

@export_category("Attacks")
@export var primary_attack: PROJECTILE
@export var secondary_attack: PROJECTILE
@export var special_attack: PROJECTILE

@export_category("Weapon Stats")
@export var weapon_type: weapon_types
@export var weapon_rarity: rarity
@export var damage: int
@export var knockback_force: float
@export var defense: int

@export_category("Other")
@export_multiline var description: String
@export var two_handed: bool
