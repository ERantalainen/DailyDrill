extends Control
@onready var minigame_container = $GameLayer/GameContainer
var total_score = 0
var games = [
	"res://ngame1/ngame_1.tscn"
]
var current_game = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minigame_container.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	$MenuItems.hide()
	$Title.hide()
	$TotalScore.hide()
	minigame_container.show()
	start_next_minigame()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func start_next_minigame():
	print("starting minigame\n")
	if current_game >= games.size():
		current_game = 0
	var minigame_scene = load(games[current_game])
	var minigame_instance = minigame_scene.instantiate()
	minigame_container.add_child(minigame_instance)
	minigame_instance.connect("game_over_return", Callable(self, "_on_minigame_over"))
	current_game += 1
	
func _on_minigame_over(score: int):
	total_score += score
	$TotalScore.text = str(total_score)
	$Title.show()
	$TotalScore.show()
	await get_tree().create_timer(2.0).timeout
	$Title.hide()
	$TotalScore.hide();
	start_next_minigame()
