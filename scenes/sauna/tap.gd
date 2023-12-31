extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func action():
	if $TapAnimation.is_playing():
		return
	$TapAnimation.play("turn", -1, -1.0 if $Particles.emitting else 1.0, $Particles.emitting)
	await $TapAnimation.animation_finished
	$Particles.emitting = ! $Particles.emitting
	set_process($Particles.emitting)

func _process(delta):
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider().has_method("on_liquid"):
			$RayCast3D.get_collider().on_liquid("water", delta*0.3)
		var distance = ($RayCast3D.get_collision_point()-$RayCast3D.get_global_position()).length()
		$Particles.lifetime = sqrt(distance*0.16)
		$Particles.amount_ratio = min(distance, 1.0)
