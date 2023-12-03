extends XRToolsPickable


@onready var raycast = $RayCast3D

var liquid_type : String

func on_liquid(type : String, quantity : float):
	$LiquidLevel.position.y += quantity*0.1
	# empty: -0.117
	# full: 0.162
	if $LiquidLevel.position.y > 0.162:
		$LiquidLevel.position.y = 0.162
	liquid_type = type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_pouring : bool = (global_transform.basis.y.y < -0.2) and ($LiquidLevel.position.y > -0.117)
	$Particles.emitting = is_pouring
	raycast.visible = is_pouring
	if is_pouring:
		$LiquidLevel.position.y -= 0.1*delta
		raycast.transform.basis = global_basis.inverse()
		if raycast.is_colliding() and raycast.get_collider().has_method("on_liquid"):
			raycast.get_collider().on_liquid(liquid_type, delta*0.1)