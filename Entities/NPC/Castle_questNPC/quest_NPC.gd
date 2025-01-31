extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea

@export var npc_id: String
@export var npc_name: String

# Dialog vars
@onready var dialog_manager: Node2D = $DialogManager
@export var dialog_resource: Dialog
var current_state = "start"
var current_branch_index = 0

func _ready() -> void:
	#Load dialog data
	dialog_resource.load_from_json("res://Common/Dialog/Dialogs/dialog_data.json")
		#Initialize npc ref
	
	
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	print("Quest Dialog opened")
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id)
	if npc_dialogs.is_empty():
		return
	dialog_manager.show_dialog(self)

#Get current bracnh dialog
func get_current_dialog():
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id)
	if current_branch_index < npc_dialogs.size():
		for dialog in npc_dialogs[current_branch_index]["dialogs"]:
			if dialog["state"] == current_state:
				return dialog
	return null

#update dialog branch
func set_dialog_tree(branch_index):
	current_branch_index = branch_index
	current_state = "start"

#Update dialog state
func set_dialog_state(state):
	current_state
