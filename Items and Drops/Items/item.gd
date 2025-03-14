class_name Item
extends Resource

enum rarity_values {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHICAL}

@export var name: String

@export var scene: PackedScene
@export var sprite: Texture

@export_multiline var description: String
@export var value: int
@export var price: int
@export var consumable: bool

@export var rarity: rarity_values
@export_enum("Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical") var rarity_string: String


@export var stackable: bool = true
@export var amount: int
