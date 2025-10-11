extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	if (body.is_in_group("enemies")):
		body.hurt()

func _hit_enemy():
	queue_free()
	
