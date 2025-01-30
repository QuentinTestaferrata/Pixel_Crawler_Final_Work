extends Control

@onready var panel: Panel = $Panel
@onready var dialog_speaker: Label = $Panel/VBoxContainer/DialogSpeaker
@onready var dialog_text: Label = $Panel/VBoxContainer/DialogText
@onready var dialog_options: HBoxContainer = $Panel/VBoxContainer/DialogOptions



func _ready() -> void:
	hide_dialog()

#Show dialog box
func show_dialog(speaker, text, options):
	panel.visible = true
	
	#Populate data
	dialog_speaker.text = speaker
	dialog_text.text = text
	
	#Remove existing options
	for option in dialog_options.get_children():
		dialog_options.remove_child(option)
	
	#Populate options
	for option in options.keys():
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("fontsize", 10)
		button.pressed.connect(_on_option_selected.bind(option))
		dialog_options.add_child(button)


#Handle response selection
func _on_option_selected(option):
	get_parent().handle_dialog_option(option)

#Hide dialog box
func hide_dialog():
	panel.visible = false

#Close dialog
func _on_texture_button_pressed() -> void:
	hide_dialog()
