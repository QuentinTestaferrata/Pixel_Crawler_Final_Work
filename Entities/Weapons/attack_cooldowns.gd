extends Node

var weapon_1_cd_1: float
var weapon_1_cd_2: float
var weapon_2_cd_1: float
var weapon_2_cd_2: float

var equiped_weapon: int = 0

var timer_1: Timer
var timer_2: Timer
var timer_3: Timer
var timer_4: Timer

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	var weapon_manager = player.find_child("Timers", true, true)
	
	timer_1 = Timer.new()
	timer_2 = Timer.new()
	timer_3 = Timer.new()
	timer_4 = Timer.new()
	timer_1.one_shot = true
	timer_2.one_shot = true
	timer_3.one_shot = true
	timer_4.one_shot = true
	weapon_manager.add_child(timer_1)
	weapon_manager.add_child(timer_2)
	weapon_manager.add_child(timer_3)
	weapon_manager.add_child(timer_4)
	

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
	if equiped_weapon == 1 and attack == 1:
		timer_1.start(weapon_1_cd_1)
	if equiped_weapon == 1 and attack == 2:
		timer_2.start(weapon_1_cd_2)
	if equiped_weapon == 2 and attack == 1:
		timer_3.start(weapon_2_cd_1)
	if equiped_weapon == 2 and attack == 2:
		timer_4.start(weapon_2_cd_2)


func check_cd(attack: int)-> bool:
	print(timer_4.time_left)
	if equiped_weapon == 1 and attack == 1 and timer_1.is_stopped():
		return true
	elif equiped_weapon == 1 and attack == 2 and timer_2.is_stopped():
		return true
	elif equiped_weapon == 2 and attack == 1 and timer_3.is_stopped():
		return true
	elif equiped_weapon == 2 and attack == 2 and timer_4.is_stopped():
		return true
	return false

func _process(delta: float) -> void:
	print(timer_4.time_left)
