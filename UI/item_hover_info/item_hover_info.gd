extends PanelContainer

@onready var _value: RichTextLabel = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/Label
@onready var _description: RichTextLabel = $MarginContainer/VBoxContainer/Description
@onready var _item_name: RichTextLabel = $MarginContainer/VBoxContainer/ItemName
@onready var _rarity_label: RichTextLabel = $MarginContainer/MarginContainer/HBoxContainer/RarityLabel

var item_name: String
var description: String
var rarity: String
var value: int

func _ready() -> void:
	_item_name.text = item_name
	_description.text = str(description)
	_rarity_label.text = rarity
	if value != 0:
		_value.text = str(": ", value)

func _process(_delta: float) -> void:
	var mousepos = get_global_mouse_position()
	global_position = mousepos + Vector2(15, -15)
