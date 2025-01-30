extends PanelContainer

@onready var save_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/SaveButton
@onready var quit_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("open")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		close_menu()
		get_tree().paused = false

func _on_save_button_pressed() -> void:
	var hud_node = get_parent()
	hud_node.save_game()

func close_menu() -> void:
	animation_player.play("close")
