extends Control

const OPTION_BUTTON = preload("res://UI/Dialog/Scenes/Option_Button.tscn")

@onready var panel: Panel = $Panel
@onready var quest_list: VBoxContainer = $Panel/Contents/Details/QuestList
@onready var quest_details: VBoxContainer = $Panel/Contents/Details/QuestDetails
@onready var quest_title: Label = $Panel/Contents/Details/QuestDetails/QuestTitle
@onready var questdescription: Label = $Panel/Contents/Details/QuestDetails/Questdescription
@onready var quest_objectives: VBoxContainer = $Panel/Contents/Details/QuestDetails/QuestObjectives
@onready var quest_rewards: VBoxContainer = $Panel/Contents/Details/QuestDetails/QuestRewards
@onready var quest_ui: Control = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var finish_quest_button: VBoxContainer = $Panel/Contents/Details/QuestDetails/finish_quest_button

var player: CharacterBody2D
var hud_layer: CanvasLayer
var temp_quest_log: Control

var selected_quest: Quest = null
var quest_manager

func _ready() -> void:
	hud_layer = get_tree().get_first_node_in_group("hud")
	player = get_tree().get_first_node_in_group("player")
	
	clear_quest_details()
	
	# Quest manager/UI connections
	quest_manager = player.get_node("QuestManager")
	quest_manager.quest_updated.connect(_on_quest_updated)
	quest_manager.objective_updated.connect(_on_objectives_updated)
	

# Show/hide qyest log
func show_hide_log():
	update_quest_list()
	print(selected_quest, "selected")
	if selected_quest:
		_on_quest_selected(selected_quest)
	
func close_quest_log():
	animation_player.play("new_animation")

# Populate quest list
func update_quest_list():
	#Remove all items
	for child in quest_list.get_children():
		quest_list.remove_child(child)
	
	# Populate with new items
	var active_quests = StatsManager.player_quests #player.get_node("QuestManager").get_active_quests()
	
	if active_quests.size() == 0:
		player.selected_quest = null
		player.update_quest_tracker(null)
	else:
		for quest in active_quests:
			var button = Button.new()
			button.add_theme_font_size_override("font_size", 10)
			button.text = quest.quest_name
			button.pressed.connect(_on_quest_selected.bind(quest))
			selected_quest = quest
			quest_list.add_child(button)
	# Update quest tracker
	print(selected_quest, "Before update")
	player.update_quest_tracker(selected_quest)

func _on_quest_selected(quest: Quest):
	selected_quest = quest
	player.selected_quest = quest
	# Populate details
	quest_title.text = quest.quest_name
	questdescription.text = quest.quest_description
	
	# Populate objectives
	for child in quest_objectives.get_children():
		quest_objectives.remove_child(child)
	
	for objective in quest.objectives:
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 10)
		
		if objective.target_type == "collection":
			
			player.check_inventory_for_quest_item(quest, "")
			label.text = objective.description + "(" + str(objective.collected_quantity) + "/" + str(objective.required_quantity) + ")"
		else: 
			label.text = objective.description
	
		if objective.is_completed:
			label.add_theme_color_override("font_color", Color(0, 0.84, 0))
			
		else:
			label.add_theme_color_override("font_color", Color(1,0, 0))
			
		quest_objectives.add_child(label)
	
	# Populate rewards
	for child in quest_rewards.get_children():
		quest_rewards.remove_child(child)
	
	for reward in quest.rewards:
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color(0, 0.84, 0))
		label.text = "Rewards: " + reward.reward_type.capitalize() 	+ ": " + str(reward.reward_amount)
		quest_rewards.add_child(label)
		
	print(quest.state)
	if quest.is_completed() and quest.state == "finished":
		
		for child in finish_quest_button.get_children():
			finish_quest_button.remove_child(child)
			child.queue_free()
		var temp_finish_quest_button = OPTION_BUTTON.instantiate()
		
		temp_finish_quest_button.text = "Finish quest"
		var font = FontFile.new()
		font.font_data = load("res://Common/Poco.ttf")
		
		temp_finish_quest_button.add_theme_font_override("font", font)
		temp_finish_quest_button.add_theme_font_size_override("font_size", 10)
		
		temp_finish_quest_button.add_theme_color_override("font_color", Color8(0x1B, 0x22, 0x36))
		temp_finish_quest_button.add_theme_constant_override("content_margin_top", 5)
		
		temp_finish_quest_button.pressed.connect(_on_finish_quest_button_pressed.bind(quest))
		finish_quest_button.add_child(temp_finish_quest_button)
		


func _on_finish_quest_button_pressed(quest: Quest):
	player.check_inventory_for_quest_item(quest, "done")
	player._on_quest_updated(quest.quest_id)
	clear_quest_details()
	


# Trigger to clear quest details
func clear_quest_details():
	quest_title.text = ""
	questdescription.text = ""
	
	for child in quest_objectives.get_children():
		quest_objectives.remove_child(child)
		
	for child in quest_rewards.get_children():
		quest_rewards.remove_child(child)
	
	for child in finish_quest_button.get_children():
		finish_quest_button.remove_child(child)

# Trigger to update quest list
func _on_quest_updated(quest_id: String):
	if selected_quest and selected_quest.quest_id == quest_id:
		_on_quest_selected(selected_quest)
	else:
		clear_quest_details()
	selected_quest = null
	
# Trigger to update quest details
func _on_objectives_updated(quest_id: String):
	print("_on_objectives_updated")
	if selected_quest and selected_quest.quest_id == quest_id:
		_on_quest_selected(selected_quest)
	else:
		clear_quest_details()
	selected_quest = null
	


func _on_texture_button_pressed() -> void:
	close_quest_log()
	print("quest log")
