extends Resource

class_name Objectives

@export var id: String
@export var description: String
@export var target_id: String
@export var target_type: String

#Talk_to objectif
@export var objective_dialog: String = ""

# Collection objective
@export var required_quantity: int = 0
@export var collected_quantity: int = 0

# Objective state
@export var is_completed: bool = false
