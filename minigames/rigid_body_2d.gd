extends RigidBody2D

var stats = {"goblin": 5, "knight": 2, "friend": -1, "archer": 1}
var health
var enemies = ["goblin", "knight", "friend", "archer"]
var base: Material
var shader: ShaderMaterial
var enemy_name
var hurting = false
signal enemy_died(points: int)
signal escaped(penalty: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var weight = PackedFloat32Array([0.4, 1, 0.75, 1.5])
	var enemy = enemies[rng.rand_weighted(weight)]
	enemy_name = enemy
	$AnimatedSprite2D.play(enemy)
	add_to_group("enemies")
	health = stats[enemy]
	base = $AnimatedSprite2D.material
	shader = ShaderMaterial.new()
	if enemy != "friend":
		linear_velocity = linear_velocity * (abs(200 - (health * 50)) + 50)
	else:
		linear_velocity *= 150

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hurt():
	hurting = true
	health -= 1
	var dmg: String = enemy_name + "hurt"
	$AnimatedSprite2D.play(dmg)
	$AudioStreamPlayer2D.play()

	var temp = linear_velocity
	linear_velocity = linear_velocity / 8
	await(get_tree().create_timer(0.5).timeout)
	linear_velocity = temp
	if (health <= 0):
		emit_signal("enemy_died", stats[enemy_name])
		shader.shader = load("res://minigames/enemy.gdshader")
		$AnimatedSprite2D.material = shader
		temp = Vector2.ZERO
		temp.y = +150
		temp.x = -60
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "rotation", -PI / 4, 1)
		linear_velocity = temp
		set_collision_layer_value(1, false)
		await(get_tree().create_timer(1).timeout)
		$AnimatedSprite2D.material = base
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_excited():
	if (health > 0):
		emit_signal("escaped", -health)
	queue_free()

func _on_body_entered(body: Node) -> void:
	hurt()
	body._hit_enemy()


func _on_animated_sprite_2d_animation_finished() -> void:
	if hurting == true:
		$AnimatedSprite2D.play(enemy_name)
		hurting = false
	
