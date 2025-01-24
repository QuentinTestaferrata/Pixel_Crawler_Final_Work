extends Node

func display_number(value: float, position: Vector2, critical: bool = false):
	randomize()
	
	var number = Label.new()
	number.global_position = position
	number.text = str(int(value))
	number.z_index = 5
	number.label_settings = LabelSettings.new()

	number.add_theme_font_override("font", load("res://Common/Poco.ttf"))
	
	var color = "#FFF"
	if critical:
		color = "#B22"
	if value == 0:
		color = "#FFF8"
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 15
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 5
	number.position.x -= 8

	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var rng = RandomNumberGenerator.new()
	var random_y = rng.randi_range(21, 27)
	var random_x = rng.randi_range(-10, 10)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	#UP
	tween.tween_property(
		number, "position:y", number.position.y - random_y, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:x", number.position.x - random_x, 0.25
	).set_ease(Tween.EASE_OUT)
	if random_x <= -1:
		tween.tween_property(
			number, "rotation_degrees", 12, 0.25
		)
	if random_x >= 1:
		tween.tween_property(
			number, "rotation_degrees", -12, 0.25
		)
	tween.tween_property(
		number, "position:y", number.position.y - 10, .5).set_ease(Tween.EASE_IN).set_delay(.25)
	tween.tween_property(number, "scale", Vector2.ZERO, .25).set_ease(Tween.EASE_IN).set_delay(.5)
	await tween.finished
	number.queue_free()
	
	
	
	
	
