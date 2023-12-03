extends Node3D

@export var effect_gradient_death : Gradient

var xr_interface: XRInterface

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	
	set_process(false)

func die(cause : String):
	print("Died from "+cause)
	#start_view_effect(effect_gradient_death, 5)

var current_effect_gradient : Gradient
var current_effect_duration : float
var current_effect_progress : float

func start_view_effect(g : Gradient, d : float = 1.0):
	current_effect_gradient = g
	current_effect_duration = d
	current_effect_progress = 0
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.get_color(0)
	$XROrigin3D/XRHead/ViewEffect.visible = true
	set_process(true)

func _process(delta):
	current_effect_progress += delta/current_effect_duration
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.sample(current_effect_progress)
	if current_effect_progress > 1.0:
		set_process(false)
