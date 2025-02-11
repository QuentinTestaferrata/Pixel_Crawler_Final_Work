extends Node2D
class_name WeaponManager



var weapon_scenes = {
	"wooden_staff": "res://Entities/Weapons/Staffs/new Wooden Staff/wooden_staff.tres",
	"bone_staff": "res://Entities/Weapons/Staffs/Bone Staff/bone_staff_data.tres",
	"bone_wand": "res://Entities/Weapons/Wands/bone_wand/bone_wand_data.tres"
}

var current_weapons: Array[Node2D] = []

var tween: Tween
var active_weapon_index: int = 0 #0 = no active weapon
var active_weapon_type: int = -1
var active_weapon: Node2D
var primary_attack: PROJECTILE
var secondary_attack: PROJECTILE

var equiped_weapon_1: WeaponData
var equiped_weapon_2: WeaponData

@onready var player: CharacterBody2D = $".."

func _ready() -> void:
	equiped_weapon_1 = StatsManager.equiped_weapon_1
	equiped_weapon_2 = StatsManager.equiped_weapon_2

func get_weapon_1() -> WeaponData:
	return equiped_weapon_1

func set_weapon(weapon: WeaponData, slot: int):
	if slot != 1 && slot != 2:
		print("Weapon slot has to be 1 or 2")
	elif slot == 1:
		equiped_weapon_1 = weapon
	else:
		equiped_weapon_2 = weapon

func equip_weapon(_weapon: WeaponData) -> void:
	if active_weapon: 
		active_weapon.queue_free()
		if tween:
			tween.kill()
	
	var weapon_instance = _weapon.scene.instantiate()
	primary_attack = _weapon.primary_attack
	secondary_attack = _weapon.secondary_attack
	active_weapon = weapon_instance
	
	add_child(weapon_instance)
	current_weapons.append(weapon_instance)
	
	active_weapon_type = _weapon.weapon_type
	
	if _weapon.weapon_type == 0:
		active_weapon_type = 0
		setup_staff(weapon_instance)
	elif _weapon.weapon_type == 1:
		active_weapon_type = 1
		setup_wand(weapon_instance)

func setup_staff(weapon_1) -> Tween:
	tween = get_tree().create_tween()

	#staff floating effect
	tween.tween_property(weapon_1, "position:y", weapon_1.position.y - 6, 0.7)
	tween.tween_property(weapon_1, "position:y", weapon_1.position.y - 3, 0.7)  
	tween.set_ease(Tween.EASE_IN)
	tween.set_loops()
	return tween

func setup_wand(weapon_1) -> Tween:
	tween = get_tree().create_tween()

	#staff floating effect
	tween.tween_property(weapon_1, "position:y", weapon_1.position.y - 6, 0.7)
	tween.tween_property(weapon_1, "position:y", weapon_1.position.y - 3, 0.7)  
	tween.set_ease(Tween.EASE_IN)
	tween.set_loops()
	return tween

func _process(_delta: float) -> void:
	match active_weapon_type:
		0: #STAFF
			if player.character_sprite.flip_h and active_weapon.position.x < 10 and active_weapon_type == 0:
				var tween_x = get_tree().create_tween()
				tween_x.tween_property(active_weapon, "position:x", active_weapon.position.x + 4, .1)
			elif !player.character_sprite.flip_h and active_weapon.position.x > -10 and active_weapon_type == 0:
				var tween_x = get_tree().create_tween()
				tween_x.tween_property(active_weapon, "position:x", active_weapon.position.x - 7, .1)
		1: #Wand
			if player.character_sprite.flip_h and active_weapon.position.x > -13 and active_weapon_type == 1:
				var tween_x = get_tree().create_tween()
				tween_x.tween_property(active_weapon, "position:x", active_weapon.position.x - 4, .07)
				tween_x.tween_property(active_weapon, "rotation", -.15, .2)
			elif !player.character_sprite.flip_h and active_weapon.position.x < 10 and active_weapon_type == 1:
				var tween_x = get_tree().create_tween()
				tween_x.tween_property(active_weapon, "position:x", active_weapon.position.x + 7, .1)
				tween_x.tween_property(active_weapon, "rotation",  .15, .2)
		2: #Shield
			pass
		3: #Sword
			pass
		4: #Dagger
			pass
		5: #Bow
			if player.character_sprite.flip_h and active_weapon.position.x > -13 and active_weapon_type == 5:
				var tween_x = get_tree().create_tween()
				active_weapon.scale = Vector2(-1, 1)
				tween_x.tween_property(active_weapon, "position:x", active_weapon.position.x - 4, .07)
				tween_x.tween_property(active_weapon, "rotation", -.15, .2)
			elif !player.character_sprite.flip_h and active_weapon.position.x < 10 and active_weapon_type == 5:
				var tween_x = get_tree().create_tween()
				active_weapon.scale = Vector2(1, 1)
				tween_x.tween_property(active_weapon, "position:x", active_weapon.position.x + 7, .1)
				tween_x.tween_property(active_weapon, "rotation",  .15, .2)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("equip_weapon_1") && equiped_weapon_1 != null:
		rotation = 0
		equip_weapon(StatsManager.equiped_weapon_1)
		set_weapon(StatsManager.equiped_weapon_1, 1)
		AttackCooldowns.set_data(1, equiped_weapon_1.primary_attack.COOLDOWN, equiped_weapon_1.secondary_attack.COOLDOWN)
	elif event.is_action_pressed("equip_weapon_2") && equiped_weapon_2 != null:
		equiped_weapon_2 = StatsManager.equiped_weapon_2
		equip_weapon(StatsManager.equiped_weapon_2)
		set_weapon(StatsManager.equiped_weapon_2, 2)
		AttackCooldowns.set_data(2, equiped_weapon_2.primary_attack.COOLDOWN, equiped_weapon_2.secondary_attack.COOLDOWN)


	#elif event.is_action_pressed("dash"):
		#print(StatsManager.equiped_weapon_1.weapon_name)
		#print(equiped_weapon_1.primary_attack)
