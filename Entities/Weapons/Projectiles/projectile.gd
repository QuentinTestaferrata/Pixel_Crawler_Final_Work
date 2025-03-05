extends Resource

class_name PROJECTILE

enum DAMAGE_TYPE {WATER, UNDEAD, FIRE, MAGIC, WIND, STONE}

@export_category("Data")
@export var NAME: String
@export var TYPE: DAMAGE_TYPE
@export var SPREAD: int
@export var DAMAGE: int
@export var MANA_COST: int
@export var SPEED: int
@export_range(0, 5, 0.01) var FIRERATE: float
@export var LIFETIME: float
@export var COOLDOWN: float
@export var KNOCKBACK_FORCE: float

@export_range(0, 100, .5) var CRIT_CHANCE: int
@export_range(1.0, 10.0, .1) var CRIT_MULTIPLYER: float

@export_category("Upgrades")
@export var item: Item
@export var amount: int
@export_range(1, 10, .05) var damage_multiplyer: float
@export_range(1, 10, .05) var price_multiplyer: float
