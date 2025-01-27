extends TextureButton

const ITEM_HOVER_INFO = preload("res://UI/item_hover_info/item_hover_info.tscn")

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func set_label(text: String) -> void:
	label.text = str(text)

func set_texture(texture: Texture, _scale: Vector2) -> void:
	texture_rect.texture = texture
	texture_rect.scale = _scale


func _on_mouse_entered() -> void:
	pass
