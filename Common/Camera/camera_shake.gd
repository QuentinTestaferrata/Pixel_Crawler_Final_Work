extends Camera2D
var shake_amount: float = 0
var default_offset: Vector2 = offset
var pos_x: int
var pos_y: int
@onready var timer: Timer = $Timer
var tween: Tween

func _ready():
	set_process(true)
	randomize()
	#tween = create_tween()

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
	
func shake(time: float, amount: float):
	await get_tree().create_timer(.25).timeout #lil timeout
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()
	
func _on_timer_timeout():
	set_process(false)
	#tween.interpolate_value(self, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)
