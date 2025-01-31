extends Control


@onready var panel: Panel = $Panel
@onready var quest_list: VBoxContainer = $Panel/Contents/Details/QuestList
@onready var quest_details: VBoxContainer = $Panel/Contents/Details/QuestDetails
@onready var quest_title: Label = $Panel/Contents/Details/QuestDetails/QuestTitle
@onready var questdescription: Label = $Panel/Contents/Details/QuestDetails/Questdescription
@onready var quest_objectives: VBoxContainer = $Panel/Contents/Details/QuestDetails/QuestObjectives
@onready var quest_rewards: VBoxContainer = $Panel/Contents/Details/QuestDetails/QuestRewards
