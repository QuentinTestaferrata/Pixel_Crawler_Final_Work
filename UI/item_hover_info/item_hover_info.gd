extends PanelContainer

@onready var _item_name: Label = $MarginContainer/VBoxContainer/ItemName
@onready var _description: Label = $MarginContainer/VBoxContainer/Description
@onready var _value: Label = $MarginContainer/VBoxContainer/Label

var item_name: String
var description: String
var value: int

func _ready() -> void:
	_item_name.text = item_name
	_description.text = str("description: ", description)
	if value != 0:
		_value.text = str("value: ", value)

func _process(_delta: float) -> void:
	var mousepos = get_global_mouse_position()
	global_position = mousepos + Vector2(15, -15)
