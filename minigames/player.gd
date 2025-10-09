extends Area2D

var	action	= true
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$cooldown.timeout.connect(_on_timer_timeout)
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (action == false):
		return 
	if Input.is_action_pressed("press_a"):
		$Path2D/PathFollow2D.progress_ratio += 0.05
		$cooldown.start(1);
		action = false
		
func _on_timer_timeout():
	action = true
