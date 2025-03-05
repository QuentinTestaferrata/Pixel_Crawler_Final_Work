extends StaticBody2D

const WEAPON_UPGRADE_DIALOG = preload("uid://cm0t6pkv5cb8m")

var HUD: CanvasLayer

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	HUD = get_tree().get_first_node_in_group("hud")

func on_interact() -> void:
	var weapon_dialog: PanelContainer = WEAPON_UPGRADE_DIALOG.instantiate()
	HUD.add_child(weapon_dialog)
