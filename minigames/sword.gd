extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$cooldown.timeout.connect()
	connect("body_entered", _on_melee_2d_body_entered)

var score = 0
var on_cooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left", false) && on_cooldown == false:
		attack()

func _on_melee_2d_body_entered(body: RigidBody2D) -> void:
	print("hello there")
	if body.is_in_group("enemies"):
		body.hurt()
		score += 1
	
func attack():
	print("hi ya")
	$sword.monitoring = true
	await(get_tree().create_timer(0.2))
	$sword.monitoring = false
	on_cooldown = true
	$sword/cooldown.start(0.2)

func _on_cooldown_timeout():
	on_cooldown = false
