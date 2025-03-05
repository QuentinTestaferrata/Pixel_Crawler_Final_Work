extends Area2D
class_name PlayerHurtbox

signal hit
signal playerHit

@export var player_health: PlayerHealthComponent
@export var health_bar: ProgressBar

var weapon: EnemyWeapon
var projectile: EnemyProjectile

@onready var player: Player = $".."
@onready var text_position: Node2D = $"../TextPosition"

func _ready() -> void:
	pass 

func _on_area_entered(area: Area2D) -> void:
	var enemy_position: Vector2
	var knockback_direction: Vector2
	
	playerHit.emit()
	#print("PLAYER IS HIT ", area.get_parent())
	
	if area.get_parent() is EnemyWeapon:
		weapon = area.get_parent()
		enemy_position = area.get_parent().get_parent().get_parent().get_parent().global_position
		knockback_direction = enemy_position.direction_to(player.global_position)
		player_health.take_damage(weapon.weapon_data.damage)
		DamageNumbers.display_number(weapon.weapon_data.damage, text_position.global_position)
		health_bar._set_health(StatsManager.current_health)
		hit.emit(weapon.weapon_data.knockback_force, knockback_direction)
		
	if area is EnemyProjectile and StatsManager.current_health > 0:
		projectile = area
		enemy_position = area.projectile_owner.global_position #area.get_parent().get_parent().get_parent().get_parent().global_position
		knockback_direction = enemy_position.direction_to(player.global_position)
		player_health.take_damage(projectile.projectile_data.DAMAGE)
		DamageNumbers.display_number(projectile.projectile_data.DAMAGE, text_position.global_position)
		health_bar._set_health(StatsManager.current_health)
		hit.emit(projectile.projectile_data.KNOCKBACK_FORCE, knockback_direction)
