extends Area2D

@export var	action_d = true
@export var	action_a = false
var screen_size
var 	last;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$cooldown.timeout.connect(_on_timer_timeout)
	screen_size = get_viewport_rect().size
	$press_d.hide()
	$press_a.hide()
	$cooldown.start(0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (action_a == true):
		$press_a.show()
		$press_d.hide()
	elif (action_d == true):
		$press_d.show()
		$press_a.hide()
	if (action_a == true || action_d == true):
		action()
		
func action():
	print("Status D: ", action_d, "Status A:", action_a)
	if Input.is_action_pressed("press_a"):
		if (action_a == true):
			$press_a.hide()
			action_a = false
			last = 1;
			if ($Path2D/PathFollow2D.progress_ratio < 1):
				$Path2D/PathFollow2D.progress_ratio += 0.05
			$cooldown.start(2);
		elif ($Path2D/PathFollow2D.progress_ratio > 0.1):
			$Path2D/PathFollow2D.progress_ratio -= 0.1
	if Input.is_action_pressed("press_d"):
		if (action_d == true):
			last = 0;
			action_d = false
			$press_d.hide()
			if ($Path2D/PathFollow2D.progress_ratio < 1):
				$Path2D/PathFollow2D.progress_ratio += 0.05
			$cooldown.start(2);
		elif ($Path2D/PathFollow2D.progress_ratio > 0.1):
			$Path2D/PathFollow2D.progress_ratio -= 0.1

func _on_timer_timeout():
	if (last == 0 && action_a == false):
		if (action_d == false):
			action_a = true
		elif ($Path2D/PathFollow2D.progress_ratio > 0.1):
			action_a = true
			action_d = false
			$Path2D/PathFollow2D.progress_ratio -= 0.1
	elif (last == 1 && action_d == false):
		if (action_a == false):
			action_d = true
		elif ($Path2D/PathFollow2D.progress_ratio > 0.1):
			action_a = false
			action_d = true
			$Path2D/PathFollow2D.progress_ratio -= 0.1
