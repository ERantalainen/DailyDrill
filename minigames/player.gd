extends Node2D

var actions = [false, false, false, false]
var action_id = ["press_a", "press_w", "press_s", "press_d"]
var action_name = ["PRESS A", "PRESS W", "PRESS S", "PRESS D"]
var screen_size
var 	rng = RandomNumberGenerator.new()
var 	last = 0;
var	action_index = 1
var	score = 0
var	speed;
var checkpoint = 0.1
signal game_over_return(score: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.seed = hash("Wario")
	$player/cooldown.timeout.connect(_on_timer_timeout)
	screen_size = get_viewport_rect().size
	$player/Path2D/PathFollow2D.progress_ratio = 0
	var red = Color(1.0, 1.0, 1.0, 1.0)
	$player/press_d.set("theme_override_colors/font_color", red)
	$player/press_d.text = "Get ready"
	action_index = 	rng.randi_range(0, 3)
	speed = 0.05
	$player/cooldown.start(1.8)
	$player/cooldown.one_shot = true
	await(get_tree().create_timer(2.0).timeout)
	$player/press_d.hide()
	$player/gametime.start(30)
	$player/gametime.timeout.connect(gameover)
	$player/boar.play("default")
	
func gameover():
	score = $player/Path2D/PathFollow2D.progress_ratio * 10
	emit_signal("game_over_return", score)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ($player/Path2D/PathFollow2D.progress_ratio == 1):
		gameover()
	if (actions[action_index] == true):
		$player/press_d.text = action_name[action_index]
		$player/press_d.show()
		action(action_index)

func action(key):
	if Input.is_action_pressed(action_id[key]):
		if (actions[key] == true):
			actions[key] = false
			$player/Path2D/PathFollow2D/AnimatedSprite2D.play("run")
			last = key;
			$player/press_d.hide()
			var tween = get_tree().create_tween()
			if ($player/Path2D/PathFollow2D.progress_ratio > 0.3 && $player/Path2D/PathFollow2D.progress_ratio < 0.55):
				$player/Path2D/PathFollow2D/AnimatedSprite2D.play("jump")
				tween.tween_property($player/Path2D/PathFollow2D, "progress_ratio", 0.55, 1)
				$AudioStreamPlayer2D.playing = true
			else:
				tween.tween_property($player/Path2D/PathFollow2D, "progress_ratio", $player/Path2D/PathFollow2D.progress_ratio + speed, 0.5)
			$player/cooldown.start(1);
		elif ($player/Path2D/PathFollow2D.progress_ratio > checkpoint):
			$player/cooldown.start(1);
			$player/Path2D/PathFollow2D.progress_ratio -= 0.05
	elif Input.is_anything_pressed():
		var tween = get_tree().create_tween()
		tween.tween_property($player/Path2D/PathFollow2D, "progress_ratio", $player/Path2D/PathFollow2D.progress_ratio - speed * 4, 0.5)
		actions[key] = false
		$player/Path2D/PathFollow2D/AnimatedSprite2D.play("fall")
		$player/press_d.hide()
		$player/cooldown.start(1);
		return


func _on_timer_timeout():
	var n = 0;
	if (actions[last] == false):
		while (n < 4):
			if (actions[n] != false):
				if ($player/Path2D/PathFollow2D.progress_ratio > checkpoint):
					var tween = get_tree().create_tween()
					$player/Path2D/PathFollow2D/AnimatedSprite2D.play("fall")
					tween.tween_property($player/Path2D/PathFollow2D, "progress_ratio", $player/Path2D/PathFollow2D.progress_ratio - speed, 0.5)
			n += 1
	else:
		actions[last] = false
		if ($player/Path2D/PathFollow2D.progress_ratio > checkpoint):
			var tween = get_tree().create_tween()
			$player/Path2D/PathFollow2D/AnimatedSprite2D.play("fall")
			tween.tween_property($player/Path2D/PathFollow2D, "progress_ratio", $player/Path2D/PathFollow2D.progress_ratio - speed, 0.5)
	set_state()

func set_state():
	var n = 0;
	$AudioStreamPlayer2D.playing = false
	action_index = rng.randi_range(0, 3)
	while n < 4:
		if (action_index == n):
			actions[n] = true
		else:
			actions[n] = false
		n += 1
		
