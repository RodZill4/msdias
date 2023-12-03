extends XRToolsPickable


@onready var raycast = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_pouring : bool = global_transform.basis.y.y < -0.2
	$Particles.emitting = is_pouring
	raycast.visible = is_pouring
	raycast.transform.basis = global_basis.inverse()
	if raycast.is_colliding() and raycast.get_collider().has_method("on_liquid"):
		raycast.get_collider().on_liquid("vodka", delta*0.1)
