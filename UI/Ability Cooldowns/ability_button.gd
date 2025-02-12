class_name AbilityButton
extends TextureButton

var total_time: float

@onready var cooldown: ProgressBar = $TextureRect/Cooldown
@onready var total_cooldown: Timer = $TotalCooldown
@onready var progress_bar_update: Timer = $ProgressBarUpdate

func set_ability_sprite(sprite: CompressedTexture2D) -> void:
	var texture_rect: TextureRect = get_child(0)
	texture_rect.texture = sprite

func start(time: float) -> void:
	cooldown.value = 100
	total_time = time
	total_cooldown.start(time)
	progress_bar_update.start()

func _on_progress_bar_update_timeout() -> void:
	var x = (total_time / total_cooldown.time_left) * 100
	cooldown.value = (total_cooldown.time_left / total_time) * 100

func _on_total_cooldown_timeout() -> void:
	cooldown.value = 0
	progress_bar_update.stop()
