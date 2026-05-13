extends Node

# AdManager.gd — Handles Google AdMob integration
# Shows interstitial and rewarded video ads

var is_initialized: bool = false
var interstitial_ready: bool = false
var rewarded_ready: bool = false

# AdMob IDs (replace with your real IDs)
const INTERSTITIAL_ID = "ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx"
const REWARDED_ID = "ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx"

func _ready() -> void:
	_initialize_ads()

func _initialize_ads() -> void:
	# Initialize AdMob
	if Engine.has_singleton("AdMob"):
		var admob = Engine.get_singleton("AdMob")
		admob.initialize()
		is_initialized = true
		_load_interstitial()
		_load_rewarded()
		print("✅ AdMob initialized")
	else:
		print("⚠️ AdMob not available (editor/dev mode)")

func _load_interstitial() -> void:
	if not is_initialized: return
	var admob = Engine.get_singleton("AdMob")
	admob.load_interstitial(INTERSTITIAL_ID)
	interstitial_ready = true

func _load_rewarded() -> void:
	if not is_initialized: return
	var admob = Engine.get_singleton("AdMob")
	admob.load_rewarded(REWARDED_ID)
	rewarded_ready = true

func show_interstitial() -> void:
	"""Show an interstitial ad between levels"""
	if not interstitial_ready:
		print("⚠️ Interstitial not ready")
		return
	var admob = Engine.get_singleton("AdMob")
	admob.show_interstitial()
	interstitial_ready = false
	_load_interstitial()

func show_rewarded_ad() -> void:
	"""Show a rewarded video ad — player gets bonus coins"""
	if not rewarded_ready:
		print("⚠️ Rewarded ad not ready")
		return
	var admob = Engine.get_singleton("AdMob")
	admob.show_rewarded()
	rewarded_ready = false
	_load_rewarded()

func _on_rewarded_earned(currency: String, amount: int) -> void:
	GameManager.coins += amount
	print("🪙 Earned ", amount, " coins from ad!")
