extends Resource

class_name PROJECTILE

enum DAMAGE_TYPE {WATER, UNDEAD, FIRE, MAGIC, WIND, STONE}

@export var scene: PackedScene

@export var NAME: String
@export var TYPE: DAMAGE_TYPE
@export var SPREAD: int
@export var DAMAGE: int
@export var MANA_COST: int
@export var SPEED: int
@export var FIRERATE: float
@export var LIFETIME: float
@export var KNOCKBACK_FORCE: float

@export_range(0, 100) var CRIT_CHANCE: int
@export_range(1.0, 10.0) var CRIT_MULTIPLYER: float
