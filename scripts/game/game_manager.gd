extends Node

# GameManager.gd — Central game state, autoloaded singleton
# Manages player progress, levels, currency, and game flow

enum GameState { MENU, PLAYING, PAUSED, LEVEL_COMPLETE, GAME_OVER }

var state: GameState = GameState.MENU
var current_level: int = 1
var unlocked_levels: int = 1
var coins: int = 0
var score: int = 0
var player_deck: Array = []
var k8s_concepts_learned: Array = []

# Kubernetes-themed resources
var cpu_cores: float = 2.0
var memory_gb: float = 4.0
var pods_deployed: int = 0
var services_running: int = 0

func _ready() -> void:
	load_progress()

func load_progress() -> void:
	var save = FileAccess.open("user://savegame.dat", FileAccess.READ)
	if save:
		current_level = save.get_32()
		unlocked_levels = save.get_32()
		coins = save.get_32()
		save.close()

func save_progress() -> void:
	var save = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	save.store_32(current_level)
	save.store_32(unlocked_levels)
	save.store_32(coins)
	save.close()

func start_level(level_id: int) -> void:
	current_level = level_id
	state = GameState.PLAYING
	get_tree().change_scene_to_file("res://scenes/game/game_board.tscn")

func complete_level() -> void:
	state = GameState.LEVEL_COMPLETE
	if current_level >= unlocked_levels:
		unlocked_levels = current_level + 1
	coins += 50 + (current_level * 10)
	save_progress()
	# Show rewarded ad after every 3 levels
	if current_level % 3 == 0:
		AdManager.show_rewarded_ad()

func learn_concept(concept: String) -> void:
	if concept not in k8s_concepts_learned:
		k8s_concepts_learned.append(concept)
		score += 100
		print("🎓 Learned: ", concept)

func add_card_to_deck(card_id: String) -> void:
	player_deck.append(card_id)
