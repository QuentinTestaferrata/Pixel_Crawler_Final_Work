extends PlayerState

@onready var dash_timer: Timer = $"../../DashTimer"
@onready var state_machine: PlayerStateMachine = $".."
@onready var player_dash: GPUParticles2D = $"../../PlayerDash"
@onready var character_sprite: AnimatedSprite2D = $"../../CharacterSprite"
@onready var player_hurtbox: Area2D = $"../../PlayerHurtbox"

func enter():
	dash_timer.start()
	player_hurtbox.monitoring = false
	state_machine.player.speed *= 4
	player_dash.scale.x = 1
	if character_sprite.flip_h == true:
		player_dash.scale.x = -1
	elif character_sprite.flip_h == false:
		player_dash.scale.x = 1
	player_dash.emitting = true

func update(_delta: float):
	if character_sprite.flip_h == true:
		player_dash.scale.x = -1
	elif character_sprite.flip_h == false:
		player_dash.scale.x = 1

func exit():
	player_dash.emitting = false
	player_hurtbox.monitoring = true

func _on_dash_timer_timeout() -> void:
	state_machine.player.speed /= 4
	if Input.get_vector("left", "right", "up", "down"):
		state_machine.change_state(self, "run")
	else: 
		state_machine.change_state(self, "idle")
