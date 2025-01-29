extends Node

@onready var saver_loader: Node = %SaverLoader

func _ready() -> void:
	saver_loader.load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
