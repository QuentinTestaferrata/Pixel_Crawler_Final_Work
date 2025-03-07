extends PanelContainer

var hud_node: CanvasLayer

@onready var save_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/SaveButton
@onready var quit_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hud_node = get_parent()
	animation_player.play("open")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		close_menu()
		get_tree().paused = false

func _on_save_button_pressed() -> void:
	hud_node.save_game()

func close_menu() -> void:
	animation_player.play("close")


func _on_quit_button_pressed() -> void:
	#hud_node.save_game()
	get_tree().quit()
