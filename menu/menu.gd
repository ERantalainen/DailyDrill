extends Control
@onready var minigame_container = $GameLayer/GameContainer
var total_score = 0
var games = [
	"res://minigames/swordgame.tscn",
	"res://ngame1/ngame_1.tscn",
	"res://ngame2/ngame_2.tscn",
	"res://minigames/stairgame.tscn",
	"res://shoot/ShootieGame.tscn"
]
var current_game = 0
var total_played
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (OS.get_name() == "HTML5"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	total_played = 0
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
	$Label.hide()
	var minigame_scene = load(games[current_game])
	var minigame_instance = minigame_scene.instantiate()
	minigame_container.add_child(minigame_instance)
	minigame_container.show()
	minigame_instance.connect("game_over_return", Callable(self, "_on_minigame_over"))
	current_game += 1
	total_played += 1
	if (total_played % games.size() == 0):
		Engine.time_scale += 0.25

func _on_minigame_over(score: int):
	minigame_container.hide()
	score += score * ((total_played / games.size()) * 1.5)
	total_score += score
	var maxi:int = 3 * total_played / games.size()
	if (maxi > (10 + (5 * ((total_played / (games.size() + 2)) * 1.5)))):
		maxi = (10 + (5 * ((total_played / (games.size() + 2)) * 1.5)))
	$Menu/Menu/TotalScore.text = str(total_score)
	$Menu.show()
	$Menu/Menu/TotalScore.show()
	await get_tree().create_timer(2.0).timeout
	if (score  > maxi):
		start_next_minigame()
	else:
		$Menu/Menu/MenuItems.show()
		$Label.show()
		total_played = 0
		current_game = games.size()
