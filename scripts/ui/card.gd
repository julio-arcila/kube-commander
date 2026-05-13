extends PanelContainer

# Card.gd — UI component for a Kubernetes card

signal card_played(card_id: String)

var card_data = null
var card_id: String = ""

func setup(card) -> void:
	card_data = card
	card_id = card.id
	$VBoxContainer/NameLabel.text = card.name
	$VBoxContainer/DescriptionLabel.text = card.description
	$VBoxContainer/CostLabel.text = "CPU: %.1f | RAM: %.1f" % [card.cost_cpu, card.cost_memory]

func _on_card_pressed() -> void:
	card_played.emit(card_id)
	queue_free()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_card_pressed()
