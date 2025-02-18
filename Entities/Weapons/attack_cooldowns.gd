extends Node

const ABILITY_COOLDOWN_CONTAINER = preload("res://UI/Ability Cooldowns/ability_cooldown_container.tscn")

var weapon_1_cd_1: float
var weapon_1_cd_2: float
var weapon_2_cd_1: float
var weapon_2_cd_2: float

var equiped_weapon: int = 0

var timer_1: Timer
var timer_2: Timer
var timer_3: Timer
var timer_4: Timer

var ability_cooldowns: PanelContainer

func _ready() -> void:
	#_hud = get_tree().get_first_node_in_group("hud")
	#ability_cooldowns = ABILITY_COOLDOWN_CONTAINER.instantiate()
	#_hud.add_child(ability_cooldowns)
	
	timer_1 = Timer.new()
	timer_2 = Timer.new()
	timer_3 = Timer.new()
	timer_4 = Timer.new()
	timer_1.one_shot = true
	timer_2.one_shot = true
	timer_3.one_shot = true
	timer_4.one_shot = true
	add_child(timer_1)
	add_child(timer_2)
	add_child(timer_3)
	add_child(timer_4)
	

func set_data(_equiped_weapon: int, cd_1: float, cd_2: float):
	if _equiped_weapon == 1:
		equiped_weapon = 1
		weapon_1_cd_1 = cd_1
		weapon_1_cd_2 = cd_2
	if _equiped_weapon == 2:
		equiped_weapon = 2
		weapon_2_cd_1 = cd_1
		weapon_2_cd_2 = cd_2

func start_cd(attack: int) -> void:
	if !ability_cooldowns:
		reset_cooldown_display()
	
	if equiped_weapon == 1 and attack == 1:
		timer_1.start(weapon_1_cd_1)
		ability_cooldowns.start_cooldown(1, weapon_1_cd_1)
	if equiped_weapon == 1 and attack == 2:
		timer_2.start(weapon_1_cd_2)
		ability_cooldowns.start_cooldown(2, weapon_1_cd_2)
	if equiped_weapon == 2 and attack == 1:
		timer_3.start(weapon_2_cd_1)
		ability_cooldowns.start_cooldown(3, weapon_2_cd_1)
	if equiped_weapon == 2 and attack == 2:
		timer_4.start(weapon_2_cd_2)
		ability_cooldowns.start_cooldown(4, weapon_2_cd_2)

func check_cd(attack: int)-> bool:
	if equiped_weapon == 1 and attack == 1 and timer_1.is_stopped():
		return true
	elif equiped_weapon == 1 and attack == 2 and timer_2.is_stopped():
		return true
	elif equiped_weapon == 2 and attack == 1 and timer_3.is_stopped():
		return true
	elif equiped_weapon == 2 and attack == 2 and timer_4.is_stopped():
		return true
	return false

func reset_cooldowns() -> void:
	timer_1.stop()
	timer_2.stop()
	timer_3.stop()
	timer_4.stop()

func reset_cooldown_display() -> void:
	var _hud_scene: CanvasLayer
	_hud_scene = get_tree().get_first_node_in_group("hud")
	ability_cooldowns = get_tree().get_first_node_in_group("ability_cooldown_container")
	if ability_cooldowns:
		ability_cooldowns.queue_free()
		ability_cooldowns = ABILITY_COOLDOWN_CONTAINER.instantiate()
		_hud_scene.add_child(ability_cooldowns)

func instantiate_cooldown_container() -> void:
	var temp_container = ABILITY_COOLDOWN_CONTAINER.instantiate() 
	var _hud_scene: CanvasLayer
	_hud_scene = get_tree().get_first_node_in_group("hud")
	_hud_scene.add_child(temp_container)
