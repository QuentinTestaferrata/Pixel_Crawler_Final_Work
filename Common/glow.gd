extends PointLight2D

@export_range(.1, 10, .1) var glow_scale: float
@export_range(.1, 4, .1) var breath_effect: float
@export_range(.5, 2.5, .05) var _energy: float = 1
@export var breathing_effect: bool
var light_tween: Tween

func _ready() -> void:
	scale = Vector2(glow_scale, glow_scale)
	energy = _energy
	if breathing_effect:
		set_light_tween()


func set_light_tween() -> void:
	light_tween = get_tree().create_tween()
	
	light_tween.tween_property(self, "scale", Vector2(glow_scale - breath_effect, glow_scale - breath_effect), .8)
	light_tween.tween_property(self, "scale", Vector2(glow_scale + breath_effect, glow_scale + breath_effect), .8)  
	
	light_tween.set_ease(Tween.EASE_IN)
	light_tween.set_loops()

func _exit_tree() -> void:
	if light_tween:
		light_tween.kill()
