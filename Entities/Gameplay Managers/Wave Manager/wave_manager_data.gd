extends Resource
class_name WaveManagerData

@export_category("Wave Settings")
@export var enemies_per_wave: int
@export var enemies_multiplyer: float
@export var spawn_rates: EnemySpawnRates

@export_range(0, 100, 1) var max_percentage_enemies_alive: float


@export_category("Wave multiplyers")
@export var EXP_per_wave: int
@export var EXP_multiplyer: float

@export var gold_per_wave: int
@export var gold_multiplyer: float

@export_category("Enemy stats multiplyers")
@export var health_multiplyer: float
@export var speed_multiplyer: float

@export_category("Wave intervals")
@export var spawn_interval: float
@export var spawn_interval_multiplyer: float
