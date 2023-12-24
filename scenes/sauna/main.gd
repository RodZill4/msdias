extends Node3D


## If non-zero, specifies the target refresh rate
@export var target_refresh_rate : float = 0

## Physics rate multiplier compared to HMD frame rate
@export var physics_rate_multiplier : int = 1


var xr_interface : XRInterface

var current_scene : Node = null


signal effect_finished()


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
	
	# Connect the OpenXR events
	xr_interface.connect("session_begun", _on_openxr_session_begun)
	
	set_process(false)
	
	#load_scene("res://scenes/restart/restart_scene.tscn", "title")
	load_scene("res://scenes/sauna/sauna_scene.tscn")

# Handle OpenXR session ready
func _on_openxr_session_begun() -> void:
	print("OpenXR: Session begun")

	# Get the reported refresh rate
	var refresh_rate : float = xr_interface.get_display_refresh_rate()
	if refresh_rate > 0:
		print("OpenXR: Refresh rate reported as ", str(refresh_rate))
	else:
		print("OpenXR: No refresh rate given by XR runtime")

	# Pick a desired refresh rate
	var desired_rate : float = target_refresh_rate if target_refresh_rate > 0 else refresh_rate
	var available_rates : Array = xr_interface.get_available_display_refresh_rates()
	if available_rates.size() == 0:
		print("OpenXR: Target does not support refresh rate extension")
	elif available_rates.size() == 1:
		print("OpenXR: Target supports only one refresh rate")
	elif desired_rate > 0:
		print("OpenXR: Available refresh rates are ", str(available_rates))
		var rate = 0.0
		for r in available_rates:
			if abs(desired_rate-r) < abs(desired_rate-rate):
				rate = r
		if rate > 0:
			print("OpenXR: Setting refresh rate to ", str(rate))
			xr_interface.set_display_refresh_rate(rate)
			refresh_rate = rate

	# Pick a physics rate
	var active_rate : float = refresh_rate if refresh_rate > 0 else 144.0
	var physics_rate : int = int(round(active_rate * physics_rate_multiplier))
	print("Setting physics rate to ", physics_rate)
	Engine.physics_ticks_per_second = physics_rate

func load_scene(scene_path : String, start_arg = null):
	var new_scene = load(scene_path).instantiate()
	add_child(new_scene)
	if current_scene:
		current_scene.queue_free()
	current_scene = new_scene
	$XROrigin3D/XRHead/ViewEffect.visible = false
	current_scene.start(start_arg)

func play_music(file_path : String):
	$XROrigin3D/XRHead/Music.stream = load(file_path)
	$XROrigin3D/XRHead/Music.play()

var current_effect_gradient : Gradient
var current_effect_duration : float
var current_effect_progress : float

func view_effect(g : Gradient, d : float = 1.0, keep : bool = false):
	start_view_effect(g, d)
	await self.effect_finished
	if not keep : 
		$XROrigin3D/XRHead/ViewEffect.visible = false

func start_view_effect(g : Gradient, d : float = 1.0):
	current_effect_gradient = g
	current_effect_duration = d
	current_effect_progress = 0
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.get_color(0)
	$XROrigin3D/XRHead/ViewEffect.visible = true
	set_process(true)

func _process(delta):
	current_effect_progress += delta
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.sample(current_effect_progress/current_effect_duration)
	if current_effect_progress > current_effect_duration:
		set_process(false)
		self.effect_finished.emit()

# Find the closest value in the array to the target
func _find_closest(values : Array, target : float) -> float:
	# Return 0 if no values
	if values.size() == 0:
		return 0.0

	# Find the closest value to the target
	var best : float = values.front()
	for v in values:
		if abs(target - v) < abs(target - best):
			best = v

	# Return the best value
	return best
