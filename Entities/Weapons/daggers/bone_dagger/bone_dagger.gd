extends Sprite2D
class_name Weapon

@onready var area_2d: Area2D = $Area2D
@export var weapon_data: EnemyWeaponData

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		pass
