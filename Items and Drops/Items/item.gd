class_name Item
extends Resource

enum rarity_values {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHICAL}

@export var name: String

@export var scene: PackedScene
@export var sprite: Texture

@export var value: int
@export var price: int

@export var rarity: rarity_values

@export var stackable: bool = true
@export var amount: int = 0
