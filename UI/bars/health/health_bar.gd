extends TextureProgressBar

@onready var current_health: int
@onready var max_health: int

func _ready() -> void:
	StatsManager.health_changed.connect(update)
	update()

func update() -> void:
	current_health = StatsManager.current_health
	max_health = StatsManager.max_health
	value = current_health * 100 / max_health
