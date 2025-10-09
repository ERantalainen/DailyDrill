extends Node
@export var target_scene: PackedScene
var score
signal game_over_return(score: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game():
	score = 0
	$Button.show()
	$TargetColor.generate_target($Wheel.section_colors[$Wheel.target_color])

func _on_wheel_end_score(received_score: int) -> void:
	score = received_score
	$HUD.show_game_over(score)
	await get_tree().create_timer(2.0).timeout
	emit_signal("game_over_return", score)
	queue_free()


func _on_button_pressed() -> void:
	$Wheel.is_stopping = true
	
