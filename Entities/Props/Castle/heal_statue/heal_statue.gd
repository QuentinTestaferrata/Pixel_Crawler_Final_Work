extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
var player: CharacterBody2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	player = get_tree().get_first_node_in_group("player")

func on_interact():
	StatsManager.current_health = StatsManager.max_health
	StatsManager.health_changed.emit()
	player.play_heal_animation()
