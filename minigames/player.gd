extends Area2D

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
	$cooldown.timeout.connect(_on_timer_timeout)
	screen_size = get_viewport_rect().size
	$press_d.show()
	$Path2D/PathFollow2D.progress_ratio = 0
	$press_a.hide()
	var red = Color(0.8,0.0,0.0,1.0)
	$press_a.set("theme_override_colors/font_color", red)
	$press_d.set("theme_override_colors/font_color", red)
	$cooldown.start(3)
	action_index = 	rng.randi_range(0, 3)
	set_state()
	speed = 0.05
	$gametime.start(30 - speed * 100)
	$gametime.timeout.connect(gameover)
	
func gameover():
	score = $Path2D/PathFollow2D.progress_ratio * 10
	emit_signal("game_over_return", score)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ($Path2D/PathFollow2D.progress_ratio == 1):
		gameover()
	if (actions[action_index] == true):
		$press_d.text = action_name[action_index]
		$press_d.show()
		action(action_index)

func action(key):
	if Input.is_action_pressed(action_id[key]):
		if (actions[key] == true):
			actions[key] = false
			$Path2D/PathFollow2D/AnimatedSprite2D.play("run")
			last = key;
			$press_d.hide()
			var tween = get_tree().create_tween()
			if ($Path2D/PathFollow2D.progress_ratio > 0.3 && $Path2D/PathFollow2D.progress_ratio < 0.55):
				$Path2D/PathFollow2D/AnimatedSprite2D.play("jump")
				tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 0.55, 1)
			else:
				tween.tween_property($Path2D/PathFollow2D, "progress_ratio", $Path2D/PathFollow2D.progress_ratio + speed, 0.5)
			$cooldown.start(1);
		elif ($Path2D/PathFollow2D.progress_ratio > checkpoint):
			$Path2D/PathFollow2D.progress_ratio -= 0.1
	elif Input.is_anything_pressed():
		var tween = get_tree().create_tween()
		if ($Path2D/PathFollow2D.progress_ratio > checkpoint):
			$Path2D/PathFollow2D.progress_ratio -= 0.2
			tween.tween_property($Path2D/PathFollow2D, "progress_ratio", $Path2D/PathFollow2D.progress_ratio - speed * 4, 0.5)
		else:
			tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 0, 0.5)
		actions[key] = false


func _on_timer_timeout():
	var n = 0;
	if (actions[last] == false):
		while (n < 4):
			if (actions[n] != false):
				if ($Path2D/PathFollow2D.progress_ratio > checkpoint):
					var tween = get_tree().create_tween()
					$Path2D/PathFollow2D/AnimatedSprite2D.play("fall")
					tween.tween_property($Path2D/PathFollow2D, "progress_ratio", $Path2D/PathFollow2D.progress_ratio - speed * 2, 0.5)
			n += 1
	else:
		actions[last] = false
		if ($Path2D/PathFollow2D.progress_ratio > checkpoint):
			var tween = get_tree().create_tween()
			$Path2D/PathFollow2D/AnimatedSprite2D.play("fall")
			tween.tween_property($Path2D/PathFollow2D, "progress_ratio", $Path2D/PathFollow2D.progress_ratio - speed * 2, 0.5)
	set_state()

func set_state():
	var n = 0;
	action_index = rng.randi_range(0, 3)
	while n < 4:
		if (action_index == n):
			actions[n] = true
		else:
			actions[n] = false
		n += 1
		
