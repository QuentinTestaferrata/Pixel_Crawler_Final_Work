extends Node2D

@onready var dialog_ui: Control = $DialogUi
@onready var character_body_2d: CharacterBody2D = $".."

var npc: CharacterBody2D

func _ready() -> void:
	npc = get_parent()

#Show dialog with data
func show_dialog(anpc, text = "", options = {}):
	# show empty box
	if text != "":
		dialog_ui.show_dialog(anpc.npc_name, text, options)
	else:
		#Show quest related dialogs
		var quest_dialog = npc.get_quest_dialog()
		if quest_dialog["text"] != "":
			dialog_ui.show_dialog(anpc.npc_name, quest_dialog["text"], quest_dialog["options"])
		#Show unrelated quest data populated data
		var dialog = anpc.get_current_dialog()
		if dialog == null:
			return
		dialog_ui.show_dialog(anpc.npc_name, dialog["text"], dialog["options"])

#Hide dialog
func hide_dialog():
	dialog_ui.hide_dialog()
	

func handle_dialog_option(option):
	#Get current dialog state
	var current_dialog = npc.get_current_dialog()
	if current_dialog == null:
		return
	
	# Update state
	var next_state = current_dialog["options"].get(option, "start")
	npc.set_dialog_state(next_state)
	print(next_state)
	
	#Handle state transitiond
	if next_state == "end":
		if npc.current_branch_index < npc.dialog_resource.get_npc_dialog(npc.npc_id).size() - 1:
			show_dialog(npc)
			npc.set_dialog_tree(npc.current_branch_index + 1)
		
	elif next_state == "exit":
		show_dialog(npc)
		npc.set_dialog_state("start")
		
	elif next_state == "give_quests":
		show_dialog(npc)
		if npc.dialog_resource.get_npc_dialog(npc.npc_id)[npc.current_branch_index]["branch_id"] == "npc_default":
			offer_remaining_quests()
		else:
			offer_quests(npc.dialog_resource.get_npc_dialog(npc.npc_id)[npc.current_branch_index]["branch_id"])
			print(npc.dialog_resource.get_npc_dialog(npc.npc_id)[npc.current_branch_index]["branch_id"])
			print("Quest given")
		show_dialog(npc)
		#To do add quest add func
	else:
		show_dialog(npc)
	

# At branch, offer all currently available quests
func offer_quests(branch_id: String):
	for quest in npc.quests:
		if quest.unlock_id == branch_id and quest.state == "not_started":
			npc.offer_quest(quest.quest_id)
	
# At default branch, offer all prevously unaccepted quests
func offer_remaining_quests():
	for quest in npc.quests:
		if quest.state == "not_started":
			npc.offer_quest(quest.quest_id)
