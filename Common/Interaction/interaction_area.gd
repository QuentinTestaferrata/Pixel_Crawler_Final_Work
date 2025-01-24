extends Area2D
class_name InteractionArea

@export var action_name: String = ""

var interact: Callable = func():
	print("No interaction method set")

#signals player entered / exited, add the to the array 
#of interactibles in the interactionmanager
func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		InteractionManager.add_area(self)

func _on_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		InteractionManager.remove_area(self)
