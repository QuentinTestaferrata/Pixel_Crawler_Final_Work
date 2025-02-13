extends Control



@onready var quest_tracker: Control = $"."
@onready var quest_tracker_color_rect: ColorRect = $QuestTrackerColorRect
@onready var details: VBoxContainer = $QuestTrackerColorRect/Details
@onready var title: Label = $QuestTrackerColorRect/Details/Title
@onready var objectives: VBoxContainer = $QuestTrackerColorRect/Details/Objectives
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func close_quest_tracker():
	animation_player.play("new_animation")
	
func update_quest_tracker(quest: Quest):
	if quest:
		title.text = quest.quest_name
		for child in objectives.get_children():
			objectives.remove_child(child)
			
		for objective in quest.objectives:
			var label = Label.new()
			label.text = objective.description
			print(quest.quest_name)
			if objective.is_completed:
				label.add_theme_color_override("font_color", Color(0, 1, 0))
			else:
				label.add_theme_color_override("font_color", Color(1,0, 0))
				label.add_theme_font_size_override("font_size", 10)
			objectives.add_child(label)
	# no active quest, hide tracker		
	else:
		close_quest_tracker()
		
