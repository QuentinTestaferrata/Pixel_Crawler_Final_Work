extends Control
const OPTION_BUTTON = preload("res://UI/Dialog/Scenes/Option_Button.tscn")
@onready var dialog_ui: Control = $"."
const DIALOG_UI = preload("res://UI/Dialog/Scenes/DialogUI.tscn")
var hud_layer: CanvasLayer
@onready var panel: Panel = $Panel
@onready var dialog_speaker: Label = $Panel/VBoxContainer/DialogSpeaker
@onready var dialog_text: Label = $Panel/VBoxContainer/DialogText
@onready var dialog_options: HBoxContainer = $Panel/VBoxContainer/DialogOptions
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var temp_dialog: Control

func _ready() -> void:
	hud_layer = get_tree().get_first_node_in_group("hud")

#Show dialog box
func show_dialog(speaker, text, options):
	
	if temp_dialog == null:
		temp_dialog = DIALOG_UI.instantiate()
		hud_layer.add_child(temp_dialog)
	
	for option in temp_dialog.dialog_options.get_children():
		temp_dialog.dialog_options.remove_child(option)
	
	#Populate data
	temp_dialog.dialog_speaker.text = speaker
	temp_dialog.dialog_text.text = text
	
	#Remove existing options
	for option in dialog_options.get_children():
		temp_dialog.dialog_options.remove_child(option)
	
	#Populate options
	for option in options.keys():
		var temp_option_button: Button = OPTION_BUTTON.instantiate()
		# temp_option_button.get_child(0).text = option
		temp_option_button.text = option
		
		var font = FontFile.new()
		font.font_data = load("res://Common/Poco.ttf")
		
		temp_option_button.add_theme_font_override("font", font)
		temp_option_button.add_theme_font_size_override("font_size", 10)
		
		temp_option_button.add_theme_color_override("font_color", Color8(0x1B, 0x22, 0x36))
		temp_option_button.add_theme_constant_override("content_margin_top", 5)
		
		temp_option_button.custom_minimum_size = Vector2(40, 14)
		temp_option_button.pressed.connect(_on_option_selected.bind(option))
		temp_dialog.dialog_options.add_child(temp_option_button)
	
	#temp_dialog.visible = true


#Handle response selection
func _on_option_selected(option):
	get_parent().handle_dialog_option(option)
	if option == "Say Goodbye":
		temp_dialog.hide_dialog()
		

#Hide dialog box
func hide_dialog():
		animation_player.play("new_animation")

#Close dialog
func _on_texture_button_pressed() -> void:
	hide_dialog()
