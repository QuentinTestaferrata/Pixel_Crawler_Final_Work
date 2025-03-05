extends Node2D

@export var left_hand: CompressedTexture2D
@export var right_hand: CompressedTexture2D
@export var sprite_sheet: CompressedTexture2D

@onready var body = $Body
@onready var left_hand_texture = $Hands/LeftHand
@onready var right_hand_texture = $Hands/RightHand

func _ready() -> void:
	body.texture = sprite_sheet
	left_hand_texture.texture = left_hand
	right_hand_texture.texture = right_hand
