extends XRToolsPickable


@export var cookey : bool = false


func on_liquid(type : String, quantity : float):
	match type:
		"water":
			pass
		"vodka":
			$PoisonGas.emitting = true
			get_node("/root/Main").die("poison gas")

func eat():
	return "poisoned cookie"
