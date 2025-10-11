extends Node2D

@export var bullet: PackedScene
@export var mob_scene: PackedScene

var shooting = false
var last = 0
var score = 0
var screen_border = 600
signal game_over_return(score: int)

func _ready() -> void:
	var cursor = load("res://shoot/assets/02.png")
	Input.set_custom_mouse_cursor(cursor)
	screen_border = get_viewport().get_visible_rect().size.y - 40
	$mob_timer.start(3)
	$gametimer.connect("timeout", gameover)
	await(get_tree().create_timer(2.8).timeout)
	$Label.hide()
	$gametimer.start(30)
	
func _process(delta: float) -> void:
	$score.text = "score: " + str(score)
	if shooting == true:
		return
	var new_pos = get_viewport().get_mouse_position().y + 30
	if (new_pos == last):
		return
	var dist: int = abs(new_pos - last)
	var time = 0.15
	if dist > 100:
		time = 0.1 * (dist % 100)
	if (new_pos > 40 && new_pos < screen_border):
		var tween = get_tree().create_tween()
		tween.tween_property($bow, "position:y", new_pos, 0.1)
		last = new_pos
	if Input.is_action_pressed("mouse_left"):
		_shoot()
		return 

func _shoot():
	if shooting == true:
		return
	$bow/AudioStreamPlayer2D.play()
	shooting = true
	$bow.play("default")
	await(get_tree().create_timer(0.1).timeout)
	var i = 0
	while (i < 6):
		await($bow.frame_changed)
		i += 1
	var arrow = bullet.instantiate()
	arrow.position = $bow.position
	var edge: Vector2
	edge.y = $bow.position.y
	edge.x = 0
	var dir = (edge - $bow.global_position).normalized()
	arrow.linear_velocity = dir * 250
	add_child(arrow)

func _on_mob_timer_timeout() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var mob = mob_scene.instantiate()
	var mob_spawn_location := $Path2D/PathFollow2D
	mob_spawn_location.progress_ratio = rng.randf()
	mob.position = mob_spawn_location.position
	var vec: Vector2 = mob.global_position
	vec.x = get_viewport().get_visible_rect().size.x
	mob.enemy_died.connect(_on_enemy_died)
	mob.escaped.connect(_on_enemy_offscreen)
	var dir = (vec - mob.global_position).normalized()
	dir.normalized()
	mob.linear_velocity = dir
	add_child(mob)
	$mob_timer.start(1.85)

func _on_bow_animation_finished() -> void:
	$bow.frame = 0
	await(get_tree().create_timer(0.1).timeout)
	shooting = false
	$bow.frame = 1
	await(get_tree().create_timer(0.1).timeout)
	$bow.frame = 2

func gameover():
	emit_signal("game_over_return", score)
	Input.set_custom_mouse_cursor(null)
	queue_free()

func _on_enemy_died(add):
	score += add

func _on_enemy_offscreen(pen):
	score += pen
