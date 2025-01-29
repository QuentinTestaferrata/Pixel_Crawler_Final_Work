extends Node
class_name PlayerStats

signal health_changed
signal exp_changed
signal exp_needed_changed
signal gold_changed
signal level_changed
signal player_died

#Potions
var max_potions: int
var current_potions: int

#EXP
var level: int = 1
var exp_needed: float = 125
var exp_current: float = 124

#Health
@onready var max_health: int = 100
@onready var current_health: int = max_health

#Gold
var gold: int = 200
var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		print_debug(player.name)

#EXP and LEVEL methods
func gain_exp(amount) -> void:
	if exp_current + amount >= exp_needed:
		var already_gained = exp_needed - exp_current
		var exp_left_for_next_level = amount - already_gained
		level_up()
		exp_current = exp_left_for_next_level
		exp_changed.emit()
		level_changed.emit()
		health_changed.emit()
		print(max_health)
	else:
		exp_current += amount
		exp_changed.emit()

func level_up() -> void:
	player = get_tree().get_first_node_in_group("player")
	level += 1
	max_health += 5
	current_health = max_health
	calculate_exp_needed()
	
	player.display_message("lvl up!", "b91763", 1)
	await get_tree().create_timer(.8).timeout 
	player.display_message("+5 hp", "ff004d", 1)
	#TODO Gain skills

func calculate_exp_needed() -> void:
	var experience = 125 * level * level
	print_debug("New exp needed: ", experience)
	exp_needed = experience

func lose_level() -> void:
	if level > 1:
		level -= 1
		print("You've lost a level (level: ", level, ")")
		max_health -= 5
		current_health = max_health
		#TODO Lose skills
	else:
		print("You can't lose a level")
	calculate_exp_needed()
	exp_current = 0

#GOLD methods
func gain_gold(amount: int) -> void:
	player = get_tree().get_first_node_in_group("player")
	gold += amount
	gold_changed.emit()
	player.display_message(str("+", amount, " gold"), "ffe85e", 1.2)
 

func spend_gold(amount: int) -> void:
	if gold - amount >= 0:
		gold -= amount
	else:
		print("Player doesn't have enough gold to spend")
