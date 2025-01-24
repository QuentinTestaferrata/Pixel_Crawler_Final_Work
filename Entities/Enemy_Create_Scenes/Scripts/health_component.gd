extends Node
class_name HealthComponent

signal health_changed(difference: int)
signal health_depleted
#signal max_health_changed(difference: int)
signal player_health_changed
signal player_max_health_changed

@export var immortal: bool = false
@onready var immortality_timer: Timer = null

@export var max_health: int
@onready var current_health: int

var health_bar: ProgressBar = null
@onready var state_machine: EnemyStateMachine = $"../StateMachine"
@onready var collision_shape_2d: CollisionShape2D = $"../HitboxComponent/CollisionShape2D"
@onready var hitbox_component: HurtboxComponent = $"../HitboxComponent"
@onready var sprite: Node2D = $"../Sprite"

func _ready() -> void:
	current_health = max_health
	health_bar = get_parent().get_node_or_null("HealthBar")
	if health_bar:
		health_bar.init_health(current_health)
		
	
	if "Player" in get_parent().name: 
		print(current_health)
		pass

func get_health():
	print(current_health, "/", max_health)

func set_max_health(value: int) -> void:
	max_health = value
	player_max_health_changed.emit()

func get_max_health() -> int:
	return max_health

func damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		health_depleted.emit()
		health_bar.queue_free()
		state_machine.force_change_state("Die")
		hitbox_component.queue_free()

func get_current_health() -> int:
	return current_health
