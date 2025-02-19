extends Sprite2D
class_name EnemyWeapon

@onready var area_2d: Area2D = $Area2D
@onready var damage_cooldown: Timer = $DamageCooldown

var _player : CharacterBody2D

@export var weapon_data: EnemyWeaponDatax

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	var _hurtbox: Area2D = _player.find_child("PlayerHurtbox")
	_hurtbox.playerHit.connect(disable_weapon)
	
	area_2d.set_collision_layer_value(1, false)
	area_2d.set_collision_layer_value(7, true)
	
	area_2d.set_collision_mask_value(1, false)
	area_2d.set_collision_mask_value(7, true)
	
	weapon_monitoring(true)
	#area_2d.monitorable = false

func weapon_monitoring(monitoring: bool) -> void:
	area_2d.set_deferred("monitorable", monitoring)

func disable_weapon() -> void:
	area_2d.set_deferred("monitorable", false)
	area_2d.set_deferred("monitoring", false)
	await get_tree().create_timer(2).timeout
	enable_weapon()

func enable_weapon() -> void:
	area_2d.set_deferred("monitorable", true)
	area_2d.set_deferred("monitoring", true)


#Make the weapon hit only fuckin once every second max
func _start_damage_cooldown() -> void:
	area_2d.set_deferred("monitorable", false)
	area_2d.set_deferred("monitoring", false)
	damage_cooldown.start(1)

func _on_damage_cooldown_timeout() -> void:
	area_2d.set_deferred("monitorable", true)
	area_2d.set_deferred("monitoring", true)
