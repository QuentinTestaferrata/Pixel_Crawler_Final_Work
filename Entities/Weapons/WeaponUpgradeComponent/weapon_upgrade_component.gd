extends Node

@export_category("Primary")
@export var item: Item
@export var amount: int
@export_range(1.1, 5, .05) var amount_multiplyer: float

@export_category("Secondary")
@export var item_2: Item
@export var amount_2: int
@export_range(1.1, 5, .05) var amount_multiplyer_2: float
