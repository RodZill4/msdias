@tool
@icon("res://addons/godot-xr-tools/editor/icons/function.svg")
class_name XRTelekinesis
extends Node3D


## Controller
@onready var _controller := XRHelpers.get_xr_controller(self)

var target_object = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_controller.button_pressed.connect(self._on_button_pressed)
	_controller.button_released.connect(self._on_button_released)
	_controller.input_vector2_changed.connect(self._on_input_vector2_changed)

func _on_input_vector2_changed(n : String, v : Vector2):
	if n == "primary":
		if $PickupPoint.picked_up_object:
			var new_position = $PickupPoint.position.x + v.y*0.02
			if new_position < 0:
				new_position = 0
			$PickupPoint.position.x = new_position

func _on_button_pressed(n : String):
	if n == "trigger_click":
		if $PickupPoint.picked_up_object != null:
			if $PickupPoint.picked_up_object.has_method("do_action"):
				$PickupPoint.picked_up_object.do_action(true)
		elif target_object and target_object.has_method("action"):
			target_object.action()
	elif n == "grip_click":
		if target_object and target_object.has_method("pick_up"):
			$PickupPoint.position.x = $Target.position.x
			$PickupPoint.pickup_object(target_object)
	else:
		print(n)
		
func _on_button_released(n : String):
	if n == "grip_click" and $PickupPoint.picked_up_object != null:
		$PickupPoint.picked_up_object.drop()
	elif n == "trigger_click" and $PickupPoint.picked_up_object != null:
		if $PickupPoint.picked_up_object.has_method("do_action"):
			$PickupPoint.picked_up_object.do_action(false)
	else:
		print(n)

func _process(delta):
	if $RayCast.is_colliding():
		var distance : float = ($RayCast.get_collision_point()-global_position).length()
		$Target.position.x = distance-0.03
		$Target.visible = true
		target_object = $RayCast.get_collider()
		var interactable : bool = false
		if target_object.has_method("action") or target_object.has_method("pick_up"):
			interactable = true
		$Target.get_surface_override_material(0).albedo_color = Color(1.0, 1.0, 1.0) if interactable else Color(0.2, 0.2, 0.2)
	else:
		$Target.visible = false
		target_object = null
