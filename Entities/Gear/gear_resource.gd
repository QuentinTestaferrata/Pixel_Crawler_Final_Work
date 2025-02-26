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
@export var damage: int
@export var defense: int
@export var speed: int
@export var extra_health: int
@export var regenaration: int
@export var fire_rate: int
@export var critical_hit: int

@export_category("Other")
@export_multiline var description: String
