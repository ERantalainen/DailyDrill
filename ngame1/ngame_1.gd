extends Node
@export var target_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$TargetTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPos.position)
	$StartTimer.start()

func _on_target_timer_timeout() -> void:
	var tar = target_scene.instantiate()
	var tar_spawn_location = $TargetPath/TargetSpawnLoc
	tar_spawn_location.progress_ratio = randf()
	tar.position = tar_spawn_location.position
	var direction = tar_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	tar.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	tar.linear_velocity = velocity.rotated(direction)
	add_child(tar)
	
func _on_score_timer_timeout() -> void:
	score += 1

func _on_start_timer_timeout() -> void:
	$TargetTimer.start()
	$ScoreTimer.start()
