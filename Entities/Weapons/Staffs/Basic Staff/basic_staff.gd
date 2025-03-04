extends Node2D

@export var projectile_instantiater: Node2D
@export_category("Primary Attack")
@export var attack_resource_1: PROJECTILE
@export var primary_projectile_amount: int
@export_category("Secondary Attack")
@export var attack_resource_2: PROJECTILE
@export var projectile_amount: int


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_attack") and AttackCooldowns.check_cd(1):
		projectile_instantiater.instantiate_projectile(1, primary_projectile_amount)
		AttackCooldowns.start_cd(1)
	if event.is_action_pressed("secondary_attack") and AttackCooldowns.check_cd(2):
		projectile_instantiater.instantiate_projectile(2, 1)
		AttackCooldowns.start_cd(2)
