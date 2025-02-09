extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent

var health_bar: ProgressBar
var knockback_direction: Vector2 = Vector2.ZERO
var hit_flash_animation_player: AnimationPlayer

@onready var hitbox_component: HurtboxComponent = $"."
@onready var damage_number_position: Node2D = $"../DamageNumberPosition"
@onready var sprite: Node2D = $"../Sprite"

func _ready():
	if get_parent().is_in_group("enemy"):
		health_bar = $"../HealthBar"
	
	hit_flash_animation_player = sprite.get_child(4)

func take_damage(projectile: PROJECTILE, knckdir: Vector2):
	randomize()
	
	sprite.play_hit_flash_animation()
	
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, 100)
	if random <= projectile.CRIT_CHANCE and health_component and health_bar:
		DamageNumbers.display_number((projectile.DAMAGE * projectile.CRIT_MULTIPLYER), damage_number_position.global_position, true)
		health_component.damage(projectile.DAMAGE * projectile.CRIT_MULTIPLYER)
		health_bar._set_health(health_component.current_health)
		knockback_direction = knckdir
		hit.emit(projectile.KNOCKBACK_FORCE, knockback_direction)
	elif random > projectile.CRIT_CHANCE and health_component and health_bar:
		DamageNumbers.display_number(projectile.DAMAGE, damage_number_position.global_position)
		health_component.damage(projectile.DAMAGE)
		health_bar._set_health(health_component.current_health)
		knockback_direction = knckdir
		hit.emit(projectile.KNOCKBACK_FORCE, knockback_direction)

func take_arrow_damage(projectile: Arrow, knckdir: Vector2):
	randomize()
	
	sprite.play_hit_flash_animation()
	
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, 100)
	if random <= projectile.crit_chance and health_component and health_bar:
		DamageNumbers.display_number((projectile.damage * projectile.crit_multiplyer), damage_number_position.global_position, true)
		health_component.damage(projectile.damage * projectile.crit_multiplyer)
		health_bar._set_health(health_component.current_health)
		knockback_direction = knckdir
		hit.emit(projectile.knockback, knockback_direction)
	elif random > projectile.crit_chance and health_component and health_bar:
		DamageNumbers.display_number(projectile.damage, damage_number_position.global_position)
		health_component.damage(projectile.damage)
		health_bar._set_health(health_component.current_health)
		knockback_direction = knckdir
		hit.emit(projectile.knockback, knockback_direction)
