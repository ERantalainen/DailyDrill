extends Control
@onready var minigame_container = $GameLayer/GameContainer
var total_score = 0
var games = [
	"res://ngame1/ngame_1.tscn",
	"res://ngame2/ngame_2.tscn"
]
var current_game = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minigame_container.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	$Menu.hide()
	$Menu/Menu/MenuItems.hide()
	minigame_container.show()
	start_next_minigame()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func start_next_minigame():
	if current_game >= games.size():
		current_game = 0
	var minigame_scene = load(games[current_game])
	var minigame_instance = minigame_scene.instantiate()
	minigame_container.add_child(minigame_instance)
	minigame_container.show()
	minigame_instance.connect("game_over_return", Callable(self, "_on_minigame_over"))
	current_game += 1
	
func _on_minigame_over(score: int):
	minigame_container.hide()
	total_score += score
	$Menu/Menu/TotalScore.text = str(total_score)
	$Menu.show()
	$Menu/Menu/TotalScore.show()
	await get_tree().create_timer(2.0).timeout
	$Menu/Menu/TotalScore.hide()
	start_next_minigame()
