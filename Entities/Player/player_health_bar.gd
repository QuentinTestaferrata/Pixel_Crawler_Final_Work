extends ProgressBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var health: int = 0

func _ready() -> void:
	size = Vector2(16, 2)
	position = Vector2(-9, -37)
	StatsManager.healed.connect(signaled)

func signaled() -> void:
	_set_health(StatsManager.current_health)
	damage_bar.value = StatsManager.current_health

func _set_health(new_health):
	var prev_health = health
	health = min (max_value, new_health)
	value = health
	
	if health <= 0:
		pass
	if health < prev_health:
		timer.start()
	else: 
		damage_bar.value = health

func init_health(_health, max_health):
	health = _health
	max_value = max_health
	value = health
	
	damage_bar.value = health
	damage_bar.max_value = max_health

func _on_timer_timeout() -> void:
	damage_bar.value = health
