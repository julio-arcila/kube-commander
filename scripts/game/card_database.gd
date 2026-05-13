extends Node

# CardDatabase.gd — Registry of all Kubernetes concept cards
# Each card teaches a k8s concept with gameplay mechanics

class KubeCard:
	var id: String
	var name: String
	var category: String  # "compute", "network", "storage", "config", "security"
	var concept: String   # The k8s concept this card teaches
	var cost_cpu: float
	var cost_memory: float
	var power: int
	var description: String
	var k8s_yaml: String   # Example YAML snippet for learning
	var image_path: String

	func _init(p_id, p_name, p_category, p_concept, p_cpu, p_mem, p_power, p_desc, p_yaml):
		id = p_id; name = p_name; category = p_category; concept = p_concept
		cost_cpu = p_cpu; cost_memory = p_mem; power = p_power
		description = p_desc; k8s_yaml = p_yaml

var cards: Dictionary = {}

func _ready() -> void:
	_register_cards()

func _register_cards() -> void:
	# ===== COMPUTE CARDS =====
	_add_card(KubeCard.new("pod", "Pod", "compute",
		"Pods are the smallest deployable units in Kubernetes",
		0.5, 0.25, 10,
		"A Pod wraps one or more containers with shared storage and network.",
		"apiVersion: v1\nkind: Pod\nmetadata:\n  name: my-pod\nspec:\n  containers:\n  - name: app\n    image: nginx"))

	_add_card(KubeCard.new("deployment", "Deployment", "compute",
		"Deployments manage ReplicaSets to provide declarative updates",
		1.0, 0.5, 25,
		"Deployments ensure a specified number of pod replicas are running.",
		"apiVersion: apps/v1\nkind: Deployment\nspec:\n  replicas: 3\n  selector:\n    matchLabels:\n      app: web"))

	_add_card(KubeCard.new("replicaset", "ReplicaSet", "compute",
		"ReplicaSets maintain a stable set of replica Pods",
		0.5, 0.25, 15,
		"Ensures a specified number of pod replicas are running at any time.",
		"apiVersion: apps/v1\nkind: ReplicaSet\nspec:\n  replicas: 3"))

	_add_card(KubeCard.new("daemonset", "DaemonSet", "compute",
		"DaemonSets ensure all nodes run a copy of a Pod",
		1.5, 0.75, 30,
		"Useful for node-level logging, monitoring, and storage daemons.",
		"apiVersion: apps/v1\nkind: DaemonSet\nspec:\n  selector:\n    matchLabels:\n      name: fluentd"))

	_add_card(KubeCard.new("statefulset", "StatefulSet", "compute",
		"StatefulSets manage stateful applications with stable identities",
		2.0, 1.0, 40,
		"Provides stable, unique network identifiers and persistent storage.",
		"apiVersion: apps/v1\nkind: StatefulSet\nspec:\n  serviceName: db\n  replicas: 3"))

	# ===== NETWORK CARDS =====
	_add_card(KubeCard.new("service", "Service", "network",
		"Services expose pods to network traffic",
		0.5, 0.1, 15,
		"Services provide stable IPs and DNS names for pods.",
		"apiVersion: v1\nkind: Service\nspec:\n  selector:\n    app: web\n  ports:\n  - port: 80"))

	_add_card(KubeCard.new("ingress", "Ingress", "network",
		"Ingress manages external HTTP access to services",
		1.0, 0.25, 25,
		"Ingress provides load balancing, SSL termination and name-based routing.",
		"apiVersion: networking.k8s.io/v1\nkind: Ingress\nspec:\n  rules:\n  - host: app.local"))

	# ===== STORAGE CARDS =====
	_add_card(KubeCard.new("pvc", "PersistentVolumeClaim", "storage",
		"PVCs request storage resources from the cluster",
		0.5, 0.5, 20,
		"PersistentVolumeClaims let pods request specific storage sizes and modes.",
		"apiVersion: v1\nkind: PersistentVolumeClaim\nspec:\n  accessModes:\n  - ReadWriteOnce\n  resources:\n    requests:\n      storage: 1Gi"))

	# ===== CONFIG CARDS =====
	_add_card(KubeCard.new("configmap", "ConfigMap", "config",
		"ConfigMaps decouple configuration from container images",
		0.25, 0.1, 10,
		"Store non-sensitive configuration data as key-value pairs.",
		"apiVersion: v1\nkind: ConfigMap\ndata:\n  DATABASE_URL: postgres://..."))

	_add_card(KubeCard.new("secret", "Secret", "config",
		"Secrets store sensitive data like passwords and tokens",
		0.25, 0.1, 10,
		"Secrets are base64-encoded and can be mounted as files or env vars.",
		"apiVersion: v1\nkind: Secret\ntype: Opaque\ndata:\n  password: c2VjcmV0"))

func _add_card(card: KubeCard) -> void:
	cards[card.id] = card

func get_card(card_id: String) -> KubeCard:
	return cards.get(card_id)

func get_cards_by_category(category: String) -> Array:
	var result: Array = []
	for card in cards.values():
		if card.category == category:
			result.append(card)
	return result

func get_all_cards() -> Array:
	return cards.values()

func get_random_card(category: String = "") -> KubeCard:
	var pool = get_cards_by_category(category) if category else get_all_cards()
	if pool.is_empty(): return null
	return pool[randi() % pool.size()]
