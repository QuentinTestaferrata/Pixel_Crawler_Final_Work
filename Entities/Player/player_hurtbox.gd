extends Area2D

signal hit
signal playerHit

@export var player_health: PlayerHealthComponent

var weapon: EnemyWeapon

@onready var player: Player = $".."
@onready var text_position: Node2D = $"../TextPosition"

func _ready() -> void:
	pass 

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is EnemyWeapon:
		weapon = area.get_parent()
		var enemy_position: Vector2 = area.get_parent().get_parent().get_parent().get_parent().global_position
		var knockback_direction = enemy_position.direction_to(player.global_position)
		player_health.take_damage(weapon.weapon_data.damage)
		DamageNumbers.display_number(weapon.weapon_data.damage, text_position.global_position)
		hit.emit(weapon.weapon_data.knockback_force, knockback_direction)
		playerHit.emit()
