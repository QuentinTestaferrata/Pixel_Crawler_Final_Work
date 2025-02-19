extends Resource
class_name EnemySpawnRates

@export_category("Enemy 1")
@export var enemy_1: PackedScene
@export_range(0, 100, 1) var spawn_rate_1: int

@export_category("Enemy 2")
@export var enemy_2: PackedScene
@export_range(0, 100, 1) var spawn_rate_2: int

@export_category("Enemy 3")
@export var enemy_3: PackedScene
@export_range(0, 100, 1) var spawn_rate_3: int

@export_category("Enemy 4")
@export var enemy_4: PackedScene
@export_range(0, 100, 1) var spawn_rate_4: int

@export_category("Rare Enemy")
@export var rare_enemy: PackedScene
@export_range(0, 100, 1) var spawn_rate_rare: int

@export_category("miniboss 1")
@export var miniboss: PackedScene
@export var wave: int

@export_category("miniboss 2")
@export var miniboss_2: PackedScene
@export var wave_2: int
