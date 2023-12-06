@tool
extends Node3D


@export var active : bool = false:
	set (value):
		active = value
		set_process(active)
		raycast.visible = active
		if not active:
			particles.amount_ratio = 0
	get:
		return active
@export var force_vertical : bool = false
@export var radius : float = 0.0
@export var liquid_type : String = "water"

@onready var raycast = $RayCast
@onready var particles = $Particles


func _process(delta):
	if force_vertical:
		raycast.transform.basis = global_basis.inverse()
		particles.transform.basis = raycast.transform.basis
	if radius > 0.0:
		var v : Vector2 = -Vector2(raycast.transform.basis.y.x, raycast.transform.basis.y.z)
		v /= v.length()
		v *= radius
		raycast.position.x = v.x
		raycast.position.z = v.y
		particles.position.x = v.x
		particles.position.z = v.y
	else:
		raycast.position = Vector3(0, 0, 0)
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.has_method("on_liquid"):
			collider.on_liquid(liquid_type, delta*0.1)
		var distance = (raycast.get_collision_point()-raycast.get_global_position()).length()
		particles.lifetime = sqrt(distance*0.16)
		particles.amount_ratio = min(distance/2, 1.0)


