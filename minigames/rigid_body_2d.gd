extends RigidBody2D

var health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("fly")
	add_to_group("enemies")
	health = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hurt():
	$AnimatedSprite2D.play("hurt")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_excited():
	queue_free()
