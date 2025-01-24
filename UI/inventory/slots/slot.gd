extends TextureButton

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func set_label(text: String) -> void:
	label.text = str(text)

func set_texture(texture: Texture, _scale: Vector2) -> void:
	texture_rect.texture = texture
	texture_rect.scale = _scale
