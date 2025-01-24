extends Sprite2D
class_name EnemyWeapon

@onready var area_2d: Area2D = $Area2D
@onready var damage_cooldown: Timer = $DamageCooldown

var _player : CharacterBody2D

@export var weapon_data: EnemyWeaponDatax

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	var _hurtbox: Area2D = _player.find_child("PlayerHurtbox")
	_hurtbox.playerHit.connect(_start_damage_cooldown)
	#area_2d.monitorable = false

func weapon_monitoring(monitoring: bool) -> void:
	area_2d.set_deferred("monitorable", monitoring)

#Make the weapon hit only fuckin once every second max
func _start_damage_cooldown() -> void:
	area_2d.set_deferred("monitorable", false)
	damage_cooldown.start()

func _on_damage_cooldown_timeout() -> void:
	area_2d.set_deferred("monitorable", true)
