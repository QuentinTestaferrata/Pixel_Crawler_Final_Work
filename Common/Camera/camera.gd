extends Camera2D

var alive: bool = true

@onready var player_dash: GPUParticles2D = $"../PlayerDash"
@onready var character_sprite: AnimatedSprite2D = $"../CharacterSprite"
@onready var shadow: Sprite2D = $"../Shadow"

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var offset_x = (mouse_pos.x - global_position.x) * 0.05  # 0.1 controls how much the camera follows the mouse
	var offset_y = (mouse_pos.y - global_position.y) * 0.05  # Adjust this value to your preference
	
	offset = Vector2(offset_x, offset_y)
	
	var mouse_position = get_global_mouse_position()
	
	##check the mouse to left or right of the sprite
	if alive:
		if mouse_position.x < global_position.x:
			character_sprite.flip_h = true
			shadow.position.x = -3
		else:
			character_sprite.flip_h = false
			player_dash.scale.x = -1
			shadow.position.x = 0
