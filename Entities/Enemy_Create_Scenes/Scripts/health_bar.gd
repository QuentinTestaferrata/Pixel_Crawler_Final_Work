extends ProgressBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var health: int = 0

func _ready() -> void:
	size = Vector2(16, 2)
	position = Vector2(-9, -37)

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

func init_health(_health):
	health = _health
	max_value = health
	value = health
	
	damage_bar.value = health
	damage_bar.max_value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
