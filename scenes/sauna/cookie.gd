extends XRToolsPickable


@export var cookey : bool = false

var soaked : bool = false

func _ready():
	if cookey:
		$KeyMesh.visible = true

func on_liquid(type : String, quantity : float):
	match type:
		"water":
			if soaked:
				return
			soaked = true
			$AnimationPlayer.play("soak")
		"vodka":
			$PoisonGas.emitting = true
			get_node("/root/Main").die("poison gas")

func eat():
	return "poisoned cookie"

func completely_soaked():
	print("Hello")
	if cookey:
		var key = load("res://scenes/sauna/key.tscn").instantiate()
		key.position = position
		add_collision_exception_with(key)
		get_parent().add_child(key)
	queue_free()
