extends Node


func calculate_damage(base_damage: float, attack: float, defense: float) -> int:
	return round(base_damage * (attack / (attack + defense)))
