@tool
extends XRToolsPickable


@onready var liquid_level = $LiquidLevel
@onready var trickle = $Trickle


func on_liquid(type : String, quantity : float):
	if  (global_transform.basis.y.y < 0.5):
		return
	liquid_level.position.y += quantity*0.1
	# empty: -0.117
	# full: 0.162
	if liquid_level.position.y > 0.162:
		liquid_level.position.y = 0.162
	trickle.liquid_type = type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_pouring : bool = (global_transform.basis.y.y < -0.2) and ($LiquidLevel.position.y > -0.117)
	trickle.active = is_pouring
	if is_pouring:
		liquid_level.position.y -= 0.01*delta
