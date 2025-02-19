extends CanvasLayer

@onready var canvas_layer: CanvasLayer = $"."
@onready var control: Control = $Control
@onready var background_image: TextureRect = $Control/BackgroundImage
@onready var play_button: Button = $Control/PlayButton
@onready var play_button_label: Label = $Control/PlayButton/PlayButtonLabel
@onready var quit_button: Button = $Control/QuitButton
@onready var quit_button_label: Label = $Control/QuitButton/QuitButtonLabel


var saver_loader: SaverLoader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Entities/Zones/castle.tscn")
	saver_loader.load_game()


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
