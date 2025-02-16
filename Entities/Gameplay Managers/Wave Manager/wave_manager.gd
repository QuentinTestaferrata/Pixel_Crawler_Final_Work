extends Node

signal enemy_killed
signal wave_cleared

const WAVE_FINISHED_DIALOG = preload("res://UI/wave_finished_dialog/wave_finished_dialog.tscn")
const SKELETON_BASE = preload("res://Entities/Enemy/dungeon_skeletons/skeleton_base.tscn")
const SKELETON_ROGUE = preload("res://Entities/Enemy/dungeon_skeletons/skeleton_rogue.tscn")
const SKELETON_KNIGHT = preload("res://Entities/Enemy/dungeon_skeletons/skeleton_knight.tscn")
const SKELETON_MAGE = preload("res://Entities/Enemy/dungeon_skeletons/mage/skeleton_mage.tscn")

@export_category("Wave Settings")
@export var enemies_per_wave: int
@export var enemies_multiplyer: float
@export var enemy_types: Array[PackedScene]

@export var EXP_per_wave: int
@export var EXP_multiplyer: float

@export var gold_per_wave: int
@export var gold_multiplyer: float

@export var spawn_interval_timer: Timer
@export var spawn_interval: float
@export var spawn_interval_multiplyer: float

#Enemy Stat Multiplyers
@export var health_multiplyer: float
@export var speed_multiplyer: float

var current_wave: int
var current_wave_kills: int
var current_wave_kills_needed: int
var total_kills: int
var spawned_enemies: int
var rng = RandomNumberGenerator.new()
var player: CharacterBody2D

@onready var enemies: Node2D = $"../Enemies"
@onready var dungeon: Node2D = $".."
@onready var spawn_points: Node = %SpawnPoints
@onready var hud_layer: CanvasLayer = $"../HUDLayer"


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.player_died.connect(_stop_wave)
	enemies.enemy_died.connect(_add_kill)
	current_wave = 1
	total_kills = 0
	spawned_enemies = 0
	spawn_interval_timer.start()

func _on_spawn_interval_timeout() -> void:
	var enemy = enemy_types[1].instantiate()
	var spawn_point: Vector2 = spawn_points.get_random_valid_spawnpoint()
	
	enemy.global_position = spawn_point
	enemies.add_child(enemy)
	spawned_enemies += 1
	if spawned_enemies >= enemies_per_wave:
		spawn_interval_timer.stop()

func _init_next_wave() -> void:
	current_wave += 1
	StatsManager.gain_gold(gold_per_wave)
	StatsManager.gain_exp(EXP_per_wave)
	
	var wave_dialog = WAVE_FINISHED_DIALOG.instantiate()
	hud_layer.add_child(wave_dialog)
	
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

func _wave_check() -> void:
	if current_wave_kills == enemies_per_wave:
		print("Wave ended! (wavemanager)")
		wave_cleared.emit()
		_init_next_wave()

func _stop_wave() -> void:
	spawn_interval_timer.stop()

func start_wave() -> void:
	spawn_interval_timer.start()
	print("Current wave kills: ", current_wave_kills)
	print("enemies per wave: ", enemies_per_wave)
