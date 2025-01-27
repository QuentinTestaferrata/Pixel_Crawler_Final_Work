extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	print("Quest Dialog opened")
	
