extends TextureButton

const ITEM_HOVER_INFO = preload("res://UI/item_hover_info/item_hover_info.tscn")

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var _hud: CanvasLayer

var temp_hover_info: PanelContainer
var item_name: String
var description: String
var value: int


func _ready() -> void:
	_hud = get_tree().get_first_node_in_group("hud")

func set_label(text: String) -> void:
	label.text = str(text)

func set_texture(texture: Texture, _scale: Vector2) -> void:
	texture_rect.texture = texture
	texture_rect.scale = _scale

func _on_mouse_entered() -> void:
	temp_hover_info = ITEM_HOVER_INFO.instantiate()
	
	if item_name != "":
		temp_hover_info.z_index = 20
		temp_hover_info.item_name = item_name
		temp_hover_info.description = description
		temp_hover_info.value = value
		
		print(item_name)
		
		_hud.add_child(temp_hover_info)

func _on_mouse_exited() -> void:
	temp_hover_info.queue_free()
