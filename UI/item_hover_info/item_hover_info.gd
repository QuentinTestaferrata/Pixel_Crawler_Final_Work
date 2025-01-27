extends PanelContainer

@onready var item_name: Label = $MarginContainer/VBoxContainer/ItemName
@onready var description: Label = $MarginContainer/VBoxContainer/Description
@onready var label: Label = $MarginContainer/VBoxContainer/Label

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
