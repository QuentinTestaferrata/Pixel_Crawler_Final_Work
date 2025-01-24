extends TextureProgressBar

func _ready() -> void:
	StatsManager.exp_changed.connect(update)
	update()

func update() -> void:
	value = StatsManager.exp_current * 100 / StatsManager.exp_needed
