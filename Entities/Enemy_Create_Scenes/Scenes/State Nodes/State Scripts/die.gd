extends EnemyState

signal died

@onready var state_machine: EnemyStateMachine
@onready var collision_shape_2d: CollisionShape2D = $"../../CollisionShape2D"

func _ready() -> void:
	state_machine = get_parent()


func enter():
	died.emit()
	state_machine.enemy.set_process(false)
	
	state_machine.body.play_die_animation()
	state_machine.attack_animations.play("RESET")
	state_machine.loot.drop_items()
	
	collision_shape_2d.queue_free()
	
	await get_tree().create_timer(2).timeout
	state_machine.enemy.queue_free()

func exit():
	pass

func update(_delta: float):
	pass
