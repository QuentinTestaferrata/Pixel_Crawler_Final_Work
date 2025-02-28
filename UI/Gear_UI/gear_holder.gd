extends TextureButton

const GEAR_HOVER_INFO = preload("res://UI/Gear_UI/gear_hover_info.tscn")
var hud_layer: CanvasLayer

var gear: WeaponData
var temp_hover_info: PanelContainer
var gear_name

func _on_mouse_entered() -> void:
	print("mouse entered")
	if temp_hover_info:
		temp_hover_info.queue_free()
	
	temp_hover_info = GEAR_HOVER_INFO.instantiate()
	 
	
	if gear:
		temp_hover_info.item_name = gear.gear_name
		temp_hover_info.description = gear.description
		temp_hover_info.value = gear.price
		
	#hud_layer.add_child(temp_hover_info)
	temp_hover_info.global_position = get_global_mouse_position() + Vector2(15, -15)
	

func _on_mouse_exited() -> void:
	if temp_hover_info:
		temp_hover_info.queue_free()
		temp_hover_info = null
