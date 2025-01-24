extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var closed: Sprite2D = $Closed
@onready var collision: CollisionShape2D = $CollisionShape2D2

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")

func on_interact():
	if closed.visible:
		closed.visible = false
		collision.disabled = true
	else: 
		closed.visible = true
		collision.disabled = false
