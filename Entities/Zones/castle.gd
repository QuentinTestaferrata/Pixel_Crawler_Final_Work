extends Node2D

@onready var saver_loader: SaverLoader = $SaverLoader

func _ready() -> void:
	saver_loader.load_game()
