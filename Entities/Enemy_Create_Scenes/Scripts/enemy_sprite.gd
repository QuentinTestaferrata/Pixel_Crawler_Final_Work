extends Node2D
class_name EnemySprite

enum weapon_types {SWORD, STAFF, DAGGER, AXE}

@export_subgroup("Left Hand")
@export var left_hand: Texture
@export var left_hand_empty: Texture

@export_subgroup("Right Hand")
@export var right_hand: Texture
@export var right_hand_empty: Texture

@export_group("Weapons")
@export var weapon_type: weapon_types
@export var left_hand_weapon: EnemyWeaponData
@export var right_hand_weapon: EnemyWeaponData

var left_weapon_scene: Sprite2D
var right_weapon_scene: Sprite2D

var left_weapon_hitbox: Area2D
var right_weapon_hitbox: Area2D

var weapon_has_hitbox: bool = false

@onready var sword_attacks: AnimationPlayer = $Attacks/SwordAttacks
@onready var axe_attacks: AnimationPlayer = $Attacks/AxeAttacks
@onready var dagger_attacks: AnimationPlayer = $Attacks/DaggerAttacks
@onready var staff_attacks: AnimationPlayer = $Attacks/StaffAttacks

@onready var body_sprite: Sprite2D = $Body/Body
@onready var left_hand_sprite: Sprite2D = $Hands/LeftHand
@onready var right_hand_sprite: Sprite2D = $Hands/RightHand
@onready var hands: Node2D = $Hands

@onready var body_animation_player: AnimationPlayer = $BodyAnimationPlayer
@onready var hand_animation_player: AnimationPlayer = $HandsAnim
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlash
@export var body: Texture

#weapon type 0 -> staff, type 3 -> sword

func _ready() -> void:
	body_sprite.texture = body
	
	if left_hand_weapon: #Sword
		left_hand_sprite.texture = left_hand
		left_weapon_scene = left_hand_weapon.scene.instantiate()
		left_hand_sprite.add_child(left_weapon_scene)
		left_weapon_scene.show_behind_parent = true
		if left_hand_weapon.weapon_type == 3:
			weapon_has_hitbox = true
			left_weapon_hitbox = left_weapon_scene.get_child(0)
			left_weapon_scene.weapon_monitoring(false)
	else:
		left_hand_sprite.texture = left_hand_empty
	
	if right_hand_weapon:
		right_hand_sprite.texture = right_hand
		right_weapon_scene = right_hand_weapon.scene.instantiate()
		right_weapon_hitbox = right_weapon_scene.get_child(0)
		right_weapon_hitbox.scale.x = -1
		right_hand_sprite.add_child(right_weapon_scene)
		right_weapon_scene.weapon_monitoring(false)
		right_weapon_scene.show_behind_parent = true
	else:
		right_hand_sprite.texture = right_hand_empty
	
	#Delete AnimationPlayers

func set_weapons_monitorable(monitorable: bool):
	if right_hand_weapon:
		right_weapon_scene.weapon_monitoring(monitorable)
	if left_hand_weapon:
		left_weapon_scene.weapon_monitoring(monitorable)

func play_run_left_animation() -> void:
	body_animation_player.play("run_left")
	hand_animation_player.play("run_left")
	
	await get_tree().process_frame
	
	if left_weapon_scene:
		left_weapon_scene.flip_h = true
		left_weapon_hitbox.scale.x = -1
	if right_weapon_scene:
		right_weapon_scene.flip_h = false
		right_weapon_hitbox.scale.x = 1

func play_run_right_animation() -> void:
	body_animation_player.play("run_right")
	hand_animation_player.play("run_right")
	
	await get_tree().process_frame
	
	if left_weapon_scene:
		left_weapon_scene.flip_h = false
		if weapon_has_hitbox:
			left_weapon_hitbox.scale.x = 1
	if right_weapon_scene:
		right_weapon_scene.flip_h = true
		if weapon_has_hitbox:
			right_weapon_hitbox.scale.x = -1

func play_idle_animation() -> void:
	body_animation_player.play("idle_right")
	hand_animation_player.play("idle_right")

func play_die_animation() -> void:
	hand_animation_player.stop()
	body_animation_player.play("die")
	hands.rotation = 0
	
	await get_tree().process_frame
	
	hide_weapons()

func play_hit_flash_animation() -> void:
	hit_flash_animation_player.play("hit_flash")

func hide_weapons() -> void:
	if left_weapon_scene:
		left_weapon_scene.queue_free()
	if right_weapon_scene:
		right_weapon_scene.queue_free()

func set_attack_animation_player() -> AnimationPlayer:
	match weapon_type:
		0: #Sword
			axe_attacks.queue_free()
			dagger_attacks.queue_free()
			staff_attacks.queue_free()
			return sword_attacks
		1: #Staff
			axe_attacks.queue_free()
			dagger_attacks.queue_free()
			sword_attacks.queue_free()
			return staff_attacks
		2: #Dagger
			sword_attacks.queue_free()
			axe_attacks.queue_free()
			staff_attacks.queue_free()
			return dagger_attacks
		3: #Axe
			sword_attacks.queue_free()
			dagger_attacks.queue_free()
			staff_attacks.queue_free()
			return axe_attacks
			
	for child in $Attacks.get_children():
		#print(child.name)
		pass
	
	return sword_attacks
