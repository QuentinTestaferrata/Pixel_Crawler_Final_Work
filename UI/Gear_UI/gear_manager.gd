extends Node
class_name GearManager

var equiped_hat: GearData
var equiped_coat: GearData
var equiped_boots: GearData
var equiped_ring: GearData
var equiped_amulet: GearData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equiped_hat = StatsManager.equiped_hat
	equiped_coat = StatsManager.equiped_coat
	equiped_boots = StatsManager.equiped_boots
	equiped_ring = StatsManager.equiped_ring
	equiped_amulet = StatsManager.equiped_amulet


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
