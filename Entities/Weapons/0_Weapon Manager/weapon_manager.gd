extends Node2D

var current_weapons: Array = []
@onready var player: CharacterBody2D = $".."

var tween: Tween
var active_weapon_index: int = 0 #0 = no active weapon
var active_weapon_type: int = -1
var active_weapon: Node2D
var primary_attack: PROJECTILE
var secondary_attack: PROJECTILE

var weapon_scenes = {
	"wooden_staff": "res://Entities/Weapons/Staffs/new Wooden Staff/wooden_staff.tres",
	"bone_staff": "res://Entities/Weapons/Staffs/Bone Staff/bone_staff_data.tres",
	"bone_wand": "res://Entities/Weapons/Wands/bone_wand/bone_wand_data.tres"
}

func _ready() -> void:
	##print("Weapon Manager loaded")
	pass

func equip_weapon(weapon_name: String) -> void:
	if active_weapon: 
		active_weapon.queue_free()
		tween.kill()

	if weapon_scenes.has(weapon_name):
		var weapon: WeaponData = load(weapon_scenes[weapon_name])
		var weapon_instance = weapon.scene.instantiate()
		primary_attack = weapon.primary_attack
		secondary_attack = weapon.secondary_attack
		active_weapon = weapon_instance
		
		add_child(weapon_instance)
		current_weapons.append(weapon_instance)
		
		active_weapon_type = weapon.weapon_type
		
		if weapon.weapon_type == 0:
			active_weapon_type = 0
			setup_staff(weapon_instance)
		elif weapon.weapon_type == 1:
			active_weapon_type = 1
			setup_wand(weapon_instance)
			
	else:
		print("Weapon scene: ", weapon_name, " doesn't exist")

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("equip_weapon_1"):
		rotation = 0
		equip_weapon("bone_staff")

	elif event.is_action_pressed("equip_weapon_2"):
		equip_weapon("bone_wand")
