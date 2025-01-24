extends Label

var seconds: int = 0
var minutes: int = 0
var minutes_enabled: bool = false

func _on_timer_timeout() -> void:
	seconds += 1
	if seconds == 60:
		seconds = 0
		minutes = 1
		minutes_enabled = true
	
	if seconds <= 9:
		text = str("0", seconds)
	if seconds >= 10 and not minutes_enabled:
		text = str(seconds)
	if seconds <= 9 and minutes_enabled:
		text = str(minutes, ":0", seconds)
	if seconds >= 10 and minutes_enabled:
		text = str(minutes, ":", seconds)
