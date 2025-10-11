extends RigidBody2D

var health 

var base: Material
var shader: ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("fly")
	add_to_group("enemies")
	health = 5
	base = $AnimatedSprite2D.material
	shader = ShaderMaterial.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hurt():
	$AnimatedSprite2D.play("hurt")
	$AudioStreamPlayer2D.play()
	shader.shader = load("res://minigames/enemy.gdshader")
	$AnimatedSprite2D.material = shader
	linear_velocity = -linear_velocity * 2
	await(get_tree().create_timer(1).timeout)
	$AnimatedSprite2D.material = base
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_excited():
	queue_free()
