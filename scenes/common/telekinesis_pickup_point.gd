@tool
extends Node3D

@export var impulse_factor : float = 1.0

@export var velocity_samples: int = 5

var picked_up_object = null:
	get:
		if not is_instance_valid(picked_up_object):
			picked_up_object = null
		return picked_up_object
var _velocity_averager := XRToolsVelocityAverager.new(velocity_samples)
var picked_up_ranged : bool = true

# Called on each frame to update the pickup
func _process(delta):
	# Calculate average velocity
	if is_instance_valid(picked_up_object) and picked_up_object.is_picked_up():
		# Average velocity of picked up object
		_velocity_averager.add_transform(delta, picked_up_object.global_transform)
	else:
		# Average velocity of this pickup
		_velocity_averager.add_transform(delta, global_transform)

func pickup_object(o):
	o.pick_up(self)
	picked_up_object = o

func drop_object() -> void:
	if not is_instance_valid(picked_up_object):
		return

	# let go of this object
	picked_up_object.let_go(
		self,
		_velocity_averager.linear_velocity() * impulse_factor,
		_velocity_averager.angular_velocity())
	picked_up_object = null
	emit_signal("has_dropped")

