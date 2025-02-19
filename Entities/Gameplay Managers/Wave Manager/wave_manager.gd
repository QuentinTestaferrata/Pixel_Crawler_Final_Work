extends Node

signal enemy_killed
signal wave_cleared

const WAVE_FINISHED_DIALOG = preload("res://UI/wave_finished_dialog/wave_finished_dialog.tscn")

@export_category("Wave Settings")
@export var enemies_per_wave: int
@export var enemies_multiplyer: float
@export var spawn_rates: EnemySpawnRates

@export_range(0, 100, 1) var max_percentage_enemies_alive: float


@export_category("Wave multiplyers")
@export var EXP_per_wave: int
@export var EXP_multiplyer: float

@export var gold_per_wave: int
@export var gold_multiplyer: float

@export_category("Enemy stats multiplyers")
@export var health_multiplyer: float
@export var speed_multiplyer: float

@export_category("Wave intervals")
@export var spawn_interval: float
@export var spawn_interval_multiplyer: float

var current_wave: int
var current_wave_kills: int
var current_wave_kills_needed: int
var total_kills: int
var spawned_enemies: int
var rng = RandomNumberGenerator.new()
var player: CharacterBody2D
var total_enemies_alive: int
var max_enemies_alive: float

@onready var enemies: Node2D = $"../Enemies"
@onready var dungeon: Node2D = $".."
@onready var spawn_points: Node = %SpawnPoints
@onready var hud_layer: CanvasLayer = $"../HUDLayer"
@onready var spawn_interval_timer: Timer = $Timer


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.player_died.connect(_stop_wave)
	enemies.enemy_died.connect(_add_kill)
	current_wave = 1
	total_kills = 0
	spawned_enemies = 0
	#spawn_interval_timer.start()
	max_enemies_alive = (max_percentage_enemies_alive / 100) * enemies_per_wave

func _on_spawn_interval_timeout() -> void:
	var enemy
	var spawn_point: Vector2 = spawn_points.get_random_valid_spawnpoint()
	var random_number: int = rng.randi_range(1, 100)
	var spawn_rate: int = 0
	
	#print(random_number)
	spawn_rate += spawn_rates.spawn_rate_1
	
	if spawned_enemies < max_enemies_alive:
		while true:
			if random_number <= spawn_rate: 
				enemy =spawn_rates.enemy_1.instantiate()
				break
			else:
				spawn_rate += spawn_rates.spawn_rate_2
			if random_number <= spawn_rate:
				enemy =spawn_rates.enemy_2.instantiate()
				break
			else:
				spawn_rate += spawn_rates.spawn_rate_3
			if random_number <= spawn_rate:
				enemy =spawn_rates.enemy_3.instantiate()
				break
			else:
				spawn_rate += spawn_rates.spawn_rate_4
			if random_number <= spawn_rate:
				enemy =spawn_rates.enemy_4.instantiate()
				break
			
		enemy.global_position = spawn_point
		enemies.add_child(enemy)
		spawned_enemies += 1
	else: 
		spawn_interval_timer.start()

		
	if spawned_enemies >= enemies_per_wave:
		spawn_interval_timer.stop()

func _init_next_wave() -> void:
	current_wave += 1
	StatsManager.gain_gold(gold_per_wave)
	StatsManager.gain_exp(EXP_per_wave)
	
	var wave_dialog = WAVE_FINISHED_DIALOG.instantiate()
	hud_layer.add_child(wave_dialog)
	
	max_enemies_alive = (max_percentage_enemies_alive / 100) * enemies_per_wave
	spawned_enemies = 0
	current_wave_kills = 0
	gold_per_wave *= gold_multiplyer
	EXP_per_wave *= EXP_multiplyer
	enemies_per_wave *= enemies_multiplyer

func _add_kill() -> void:
	total_kills += 1
	current_wave_kills += 1
	_wave_check()
	enemy_killed.emit()
	max_enemies_alive += 1

func _wave_check() -> void:
	if current_wave_kills >= enemies_per_wave:
		print("Wave ended! (wavemanager)")
		wave_cleared.emit()
		_init_next_wave()

func _stop_wave() -> void:
	spawn_interval_timer.stop()

func start_wave() -> void:
	spawn_interval_timer.start()
	print("Current wave kills: ", current_wave_kills)
	print("enemies per wave: ", enemies_per_wave)
