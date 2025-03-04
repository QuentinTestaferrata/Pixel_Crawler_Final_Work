extends Resource
class_name GearData

enum gear_types {HAT, COAT, BOOTS, RING, AMULET}
enum rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHICAL}

@export_category("Gear Data")
@export var gear_name: String
@export var scene: PackedScene
@export var sprite: Texture
@export var shop_sprite: Texture
@export var price: int
@export var obtained: bool = false
@export var equip_slot: int = 0

@export_category("Gear Stats")
@export var gear_type: gear_types
@export var gear_rarity: rarity
@export var damage_multiplier: int
@export var defense: int #Te zien
@export var speed_multiplier: int
@export var extra_health: int
@export var regenaration: int
@export var fire_rate_multiplier: int
@export var critical_hit_multiplier: int
