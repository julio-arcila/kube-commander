extends Control

# MainMenu.gd — Title screen with level selection

@onready var title_label = $VBoxContainer/TitleLabel
@onready var play_button = $VBoxContainer/PlayButton
@onready var level_select = $VBoxContainer/LevelSelect
@onready var coins_label = $VBoxContainer/CoinsLabel
@onready var version_label = $VersionLabel

func _ready() -> void:
	coins_label.text = "🪙 " + str(GameManager.coins)
	_update_level_buttons()
	
	# Animate title
	var tween = create_tween()
	tween.tween_property(title_label, "modulate:a", 0.0, 0.0)
	tween.tween_property(title_label, "modulate:a", 1.0, 1.0)

func _update_level_buttons() -> void:
	for i in range(1, 11):  # 10 levels
		var btn = Button.new()
		btn.text = "Level " + str(i) + "\n" + _level_name(i)
		btn.disabled = i > GameManager.unlocked_levels
		btn.pressed.connect(_on_level_pressed.bind(i))
		level_select.add_child(btn)

func _level_name(level: int) -> String:
	var names = {
		1: "Your First Pod",
		2: "Scaling with Deployments",
		3: "Service Discovery",
		4: "ConfigMaps & Secrets",
		5: "Persistent Storage",
		6: "Ingress Routing",
		7: "Stateful Applications",
		8: "DaemonSets Everywhere",
		9: "Cluster Hardening",
		10: "The Production Cluster",
	}
	return names.get(level, "Challenge")

func _on_level_pressed(level_id: int) -> void:
	GameManager.start_level(level_id)

func _on_play_pressed() -> void:
	GameManager.start_level(GameManager.current_level)

func _on_learn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/kube_pedia.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
