class_name Player
extends CharacterBody2D

signal player_died

const INVENTORY_HUD = preload("res://UI/inventory/inventory_&_profile.tscn")
const PAUSE_MENU = preload("res://UI/Pause_Menu/pause_menu.tscn")
const QUEST_UI = preload("res://UI/Quests/Scene/QuestUI.tscn")
const QUEST_TRACKER_UI = preload("res://UI/Quests/QuestHUD/QuestTracker.tscn")

@export var speed: int = 100

@export_category("Potion Cooldowns")
@export var HealthPotionCD: int = 30
@export var SpeedPotionCD: int = 60

var inventory: Inventory = Inventory.new()
var inventory_open: bool = false
var temp_pause_menu: PanelContainer
#----------------------------
var temp_quest_menu: Control
# Dialogs and Quests vars
var selected_quest: Quest = null


@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var camera: Camera2D = $Camera
@onready var text_position: Node2D = $TextPosition
@onready var player_dash: GPUParticles2D = $Particles/PlayerDash
@onready var heal_particles: CPUParticles2D = $Particles/HealParticles
@onready var speed_particles: CPUParticles2D = $Particles/SpeedParticles
@onready var speed_timer: Timer = $Timers/SpeedTimer
@onready var shadow: Sprite2D = $Shadow
@onready var weapon_manager: WeaponManager = $WeaponManager

@onready var health_component: PlayerHealthComponent = $HealthComponent
@onready var heal_cooldown: Timer = $Timers/HealCooldown
@onready var speed_cooldown: Timer = $Timers/SpeedCooldown

@onready var quest_manager: QuestManager = $QuestManager
@onready var player = get_tree().get_first_node_in_group("player")


func on_item_picked_up(item: Item) -> void:
	inventory.add_item(item)
	check_inventory_for_quest_item(selected_quest)

func _ready() -> void:
	player_dash.emitting = false


	print(weapon_manager)
	
	#---------------------------------------------------------
	#signal connectrions
	quest_manager.quest_updated.connect(_on_quest_updated)
	quest_manager.objective_updated.connect(_on_objective_updated)
	print(quest_manager)
	

func _process(delta: float) -> void:
	check_inventory_for_quest_item(selected_quest)
	



func _input(event: InputEvent) -> void:
	var hud_scene: CanvasLayer = get_parent().get_child(0)
	
	if event.is_action_pressed("open_inventory") and !inventory_open:
		var _inventory = INVENTORY_HUD.instantiate()
		hud_scene.add_child(_inventory)
		inventory_open = true
		
	elif event.is_action_pressed("open_inventory") and inventory_open:
		var temp_inv = hud_scene.find_child("Inventory", true, false)
		temp_inv.close_inventory()
		inventory_open = false
		
	if event.is_action_pressed("esc") and temp_pause_menu == null:
		temp_pause_menu = PAUSE_MENU.instantiate()
		hud_scene.add_child(temp_pause_menu)
		get_tree().paused = true
		
	elif event.is_action_pressed("esc") and temp_pause_menu != null:
		get_tree().paused = false
		var temp_menu = hud_scene.find_child("PauseMenu", true, false)
		temp_menu.close_menu()
	## TODO : get rid of heal and speed inputs here and put the in potions_container.tscn
	if event.is_action_pressed("heal") and heal_cooldown.is_stopped():
		var potion: Item = inventory.get_item_by_name("Healing Potion")
		if potion == null:
			print("No more heal potions left")
		else:
			if potion.amount > 0:
				play_heal_animation()
				potion.amount -= 1
				health_component.heal(20)
	
	elif event.is_action_pressed("speed") and speed_cooldown.is_stopped():
		var potion: Item = inventory.get_item_by_name("Speed Potion")
		if potion == null:
			print("No more speed potions left")
		else: 
			if potion.amount > 0:
				play_speed_animation()
				potion.amount -= 1

	
	if event.is_action_pressed("heal") and StatsManager.current_potions > 0:
		StatsManager.current_potions -= 1
		play_heal_animation()
	
	#-------------------------------------------------------------------------
	if event.is_action_pressed("ui_quest_menu") and temp_quest_menu == null:
		temp_quest_menu = QUEST_UI.instantiate()
		hud_scene.add_child(temp_quest_menu)
		
		temp_quest_menu.show_hide_log()
	elif event.is_action_pressed("ui_quest_menu") and temp_quest_menu != null:
		var temp_quest = hud_scene.find_child("QuestUi", true, false)
		temp_quest.close_quest_log()
	
	


func play_heal_animation() -> void:
	heal_particles.top_level = false
	heal_particles.local_coords = true
	heal_particles.emitting = true
	heal_cooldown.start()

func play_speed_animation() -> void:
	speed_particles.top_level = false
	speed_particles.local_coords = false
	speed_particles.emitting = true
	speed_cooldown.start()
	speed_timer.start()
	speed += 75

func _on_speed_timer_timeout() -> void:
	speed_particles.emitting = false
	speed -= 75

func display_message(text: String, color: Color, duration: float) -> void:
	print_debug("Message sent")
	var message = Label.new()
	
	message.global_position = Vector2(text_position.position.x - 13, text_position.position.y - 2)
	message.text = text
	message.z_index = 6
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.set_anchor(SIDE_TOP, 1)
	message.add_theme_font_override("font", load("res://Common/Poco.ttf"))
	
	message.label_settings = LabelSettings.new()
	message.label_settings.font_color = color
	message.label_settings.font_size = 9
	message.label_settings.outline_color = "#000"
	message.label_settings.outline_size = 3
	
	call_deferred("add_child", message)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(message, "position:y", message.position.y - 5, .5)
	if duration > .7:
		tween.tween_property(message, "scale", Vector2(1,1), (duration - .7))
	
	tween.tween_property(message, "modulate:a", 0, .2)
	tween.tween_callback(message.queue_free)

func flip_sprite() -> void:
	if character_sprite.flip_h == true:
		shadow.position.x -= 10

#--------------------------------------------------------------------------------------------------------------------------------------------
# Check if quest item is needed
func is_item_needed(item_id: String) -> bool:
	var player = get_tree().get_first_node_in_group("player")
	var my_item
	if selected_quest != null:
		for objective in selected_quest.objectives:
			if objective.target_type == "collection" and not objective.is_completed:
				my_item = player.inventory.get_item_by_name(item_id) 
				print(my_item.amount)
				return my_item.amount
			#if objective.target_id == item_id and objective.target_type == "collection" and not objective.is_completed:
				#return true
				
	return false

func check_inventory_for_quest_item(quest: Quest):
	var my_item
	if selected_quest != null:
		for objective in quest.objectives:
			if objective.target_type == "collection" and not objective.is_completed:
				my_item = player.inventory.get_item_by_name(objective.target_id) 
				print(my_item.amount)
				quest.complete_objectives(objective.id, my_item.amount)
	pass

func check_quest_objectives(target_id: String, target_type: String, quantity: int = 1):
	if selected_quest == null:
		return
	
	# Update objectives
	var objective_updated = false
	for objective in selected_quest.objectives:
		if objective.target_id == target_id and objective.target_type ==  target_type and not objective.is_completed:
			print("Completing objective for quest: ", selected_quest.quest_name)
			selected_quest.complete_objectives(objective.id, quantity)
			objective_updated = true
			break
	
	# Provide rewards
	if objective_updated:
		if selected_quest.is_completed():
			handle_quest_completion(selected_quest)
	
	#update Ui
	print(selected_quest, "check_quest_objectives")
	update_quest_tracker(selected_quest)

	# Player rewards

# Player rewards
func handle_quest_completion(quest: Quest):
	for reward in quest.rewards:
		if reward.reward_type == "coins":
			StatsManager.gain_gold(reward.reward_amount)
			print(quest, "handle_quest_completion")
			update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")
	

#update tracker Ui
func update_quest_tracker(quest: Quest):
	# if we have an active quest, populate tracker
	var temp_quest_tracker: Control = QUEST_TRACKER_UI.instantiate()
	var hud_scene = get_tree().get_first_node_in_group("hud")
	hud_scene.add_child(temp_quest_tracker)
	temp_quest_tracker.update_quest_tracker(quest)

# Update tracker if quest is complete
func _on_quest_updated(quest_id: String):
	var quest = quest_manager.get_quest(quest_id)
	if quest == selected_quest:
		print(quest, "_on_quest_updated")
		update_quest_tracker(quest)
	selected_quest = null
	
# Update tracker if objective is complete
func _on_objective_updated(quest_id: String, objective_id: String):
	if selected_quest and selected_quest.quest_id == quest_id:
		print(selected_quest, "_on_objective_updated")
		update_quest_tracker(selected_quest)
	selected_quest = null

func make_quest_tracker():
	pass
