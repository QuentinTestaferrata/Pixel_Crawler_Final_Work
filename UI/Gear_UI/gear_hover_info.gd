extends PanelContainer

@onready var _gear_hover_info: PanelContainer = $"."
@onready var _margin_container: MarginContainer = $MarginContainer
@onready var _v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var _item_name: Label = $MarginContainer/VBoxContainer/ItemName
@onready var _stat_list: VBoxContainer = $MarginContainer/VBoxContainer/StatList

var gear: GearData

func _ready() -> void:
	if gear:
		update_gear_info(gear)

func update_gear_info(gear: GearData) -> void:
	_item_name.text = gear.gear_name  
	
	
	for child in _stat_list.get_children():
		child.queue_free()
	
	var stats = {
		"Extra Health": gear.extra_health,
		"Regeneration": gear.regenaration,
		"Speed Bonus": gear.speed_multiplier,
		"Damage Bonus": gear.damage_multiplier,
		"Fire Rate Bonus": gear.fire_rate_multiplier,
		"Critical Hit Bonus": gear.critical_hit_multiplier
	}
	
	var font = FontFile.new()
	font.font_data = load("res://Common/Poco.ttf")  
	
	
	for stat_name in stats.keys():
		var value = stats[stat_name]
		if value != 0:  #Check if stats are not 0
			var stat_label = Label.new()
			stat_label.text = stat_name + ": " + str(value) + ("%" if stat_name != "Extra Health" and stat_name != "Regeneration" else "")
			
			
			stat_label.add_theme_font_override("font", font)
			stat_label.add_theme_font_size_override("font_size", 10)
			stat_label.add_theme_color_override("font_color", Color8(0x1B, 0x22, 0x36))
			
			_stat_list.add_child(stat_label)  
	

func _process(_delta: float) -> void:
	var mousepos = get_global_mouse_position()
	global_position = mousepos + Vector2(15, -15)
