extends Node2D

@export var mob_scene: PackedScene
@export var sword_damage: int = 1
@export var attack_time: float = 0.2
@export var hurt_interval: float = 0.25

var score: int = 0
var health: int = 0
var attacking := false
var hit_this_swing := {}
signal game_over_return(score: int)

@onready var player_hitbox: Area2D = $Player
@onready var player_dmg_timer: Timer = $Player/damagetimer
@onready var sword: Area2D = $Player/sword
@onready var sword_cooldown: Timer = $Player/sword/cooldown
@onready var mob_timer: Timer = $mobtimer

func _ready() -> void:
	health = 5
	player_hitbox.body_entered.connect(_on_player_hitbox_body_entered)
	sword.body_entered.connect(_on_sword_body_entered)
	player_dmg_timer.timeout.connect(_on_damage_tick)
	sword_cooldown.timeout.connect(_on_cooldown_timeout)
	sword_cooldown.one_shot = true
	$Player/AnimatedSprite2D.play("idle")
	mob_timer.timeout.connect(_on_mob_timer_timeout)
	mob_timer.start(1.0)
	$Player/health.value = 5

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		attack()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location := $MobPath/MobSpawn
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	var player_pos: Vector2 = $Player.global_position
	var dir = (player_pos - mob.global_position).normalized()
	mob.linear_velocity = dir * randf_range(150.0, 250.0)
	mob.rotation = dir.angle()
	add_child(mob)

func _on_player_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and not player_dmg_timer.is_stopped():
		return
	if body.is_in_group("enemies"):
		player_dmg_timer.start(hurt_interval)

func _on_damage_tick() -> void:
	var bodies := player_hitbox.get_overlapping_bodies()
	var has_enemy := false
	for b in bodies:
		if b.is_in_group("enemies"):
			has_enemy = true
			break
	if has_enemy:
		health -= 1
		$Player/health.value -= 1
		$Player/AnimatedSprite2D.play("hurt")
		if health <= 0:
			gameover()
			return
		player_dmg_timer.start(hurt_interval)
	else:
		player_dmg_timer.stop()

func attack():
	if attacking or sword_cooldown.time_left > 0.0:
		return
	$Player/AnimatedSprite2D.play("attack")
	attacking = true
	hit_this_swing.clear()
	for b in sword.get_overlapping_bodies():
		_try_hit_enemy_with_sword(b)
	await get_tree().create_timer(attack_time).timeout
	attacking = false
	sword_cooldown.start(0.5)

func _on_sword_body_entered(body: Node) -> void:
	if attacking:
		_try_hit_enemy_with_sword(body)

func _try_hit_enemy_with_sword(body: Node) -> void:
	if not body.is_in_group("enemies"):
		return
	if body in hit_this_swing:
		return
	hit_this_swing[body] = true
	if body.has_method("hurt"):
		body.hurt()
		score += 1

func _on_cooldown_timeout():
	$Player/AnimatedSprite2D.play("idle")

func gameover() -> void:
	emit_signal("game_over_return", score)
	queue_free()
