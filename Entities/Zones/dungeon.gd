extends Node

@onready var saver_loader: SaverLoader = $SaverLoader
@onready var enemies: Node2D = $Enemies

func _ready() -> void:
	saver_loader.load_game()
