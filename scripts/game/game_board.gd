extends Node2D

# GameBoard.gd — Main gameplay scene
# Player deploys k8s resources (cards) to handle incoming requests

@onready var card_hand = $UI/CardHand
@onready var deploy_zone = $DeployZone
@onready var cpu_label = $UI/ResourceBar/CPULabel
@onready var memory_label = $UI/ResourceBar/MemoryLabel
@onready var score_label = $UI/ResourceBar/ScoreLabel
@onready var wave_label = $UI/ResourceBar/WaveLabel
@onready var card_preview = $UI/CardPreview

var current_deck: Array = []
var available_cards: Array = []
var incoming_requests: Array = []
var wave: int = 1
var max_waves: int = 5

func _ready() -> void:
	_setup_level()
	_update_resources()

func _setup_level() -> void:
	var level = GameManager.current_level
	
	# Give player starter cards based on level
	current_deck = ["pod"]
	if level >= 2: current_deck.append("deployment")
	if level >= 3: current_deck.append("service")
	if level >= 4: current_deck.append("configmap")
	if level >= 5: current_deck.append("pvc")
	
	_draw_cards(4)

func _draw_cards(count: int) -> void:
	for i in range(count):
		var card_id = current_deck[randi() % current_deck.size()]
		available_cards.append(card_id)
		DisplayCard(card_id)

func DisplayCard(card_id: String) -> void:
	var card = CardDatabase.get_card(card_id)
	if not card: return
	
	var card_scene = load("res://scenes/game/card.tscn")
	var card_instance = card_scene.instantiate()
	card_instance.setup(card)
	card_instance.card_played.connect(_on_card_played)
	card_hand.add_child(card_instance)

func _on_card_played(card_id: String) -> void:
	var card = CardDatabase.get_card(card_id)
	if GameManager.cpu_cores < card.cost_cpu or GameManager.memory_gb < card.cost_memory:
		print("⚠️ Not enough resources!")
		return
	
	GameManager.cpu_cores -= card.cost_cpu
	GameManager.memory_gb -= card.cost_memory
	GameManager.pods_deployed += 1
	GameManager.score += card.power
	
	# Learn the concept when card is first played
	GameManager.learn_concept(card.concept)
	
	_update_resources()

func _update_resources() -> void:
	cpu_label.text = "CPU: %.1f cores" % GameManager.cpu_cores
	memory_label.text = "RAM: %.1f GB" % GameManager.memory_gb
	score_label.text = "Score: %d" % GameManager.score
	wave_label.text = "Wave %d/%d" % [wave, max_waves]

func _on_wave_complete() -> void:
	wave += 1
	if wave > max_waves:
		GameManager.complete_level()
	else:
		_draw_cards(2)
		_update_resources()
