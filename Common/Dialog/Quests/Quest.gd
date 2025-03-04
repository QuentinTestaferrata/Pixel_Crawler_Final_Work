extends Resource

class_name Quest

@export var quest_id: String
@export var quest_name: String
@export_multiline var quest_description: String
@export var state: String = "not_started"
@export var unlock_id: String
@export var objectives: Array[Objectives] = []
@export var rewards: Array[Rewards] = []


# Check objectives state
func is_completed() -> bool:
	for objective in objectives:
		if not objective.is_completed:
			return false
	return true
	

func get_paid():
	state = "completed"

# Update quest state
func complete_objectives(objective_id: String, quantity: int = 1):
	for objective in objectives:
		if objective.id == objective_id:
			if objective.target_type == "collection":
				objective.collected_quantity = quantity
				if objective.collected_quantity >= objective.required_quantity:
					objective.is_completed = true
			# Talk to objective
			elif objective.target_type == "talk_to":
				objective.is_completed = true
			break
	
	
	# If all objectives completed mark quest as completed
	if is_completed():
		if state != "quest_paid":
			state = "finished"
			
		
