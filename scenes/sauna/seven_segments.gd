@tool
extends Node3D


@onready var segments : Array[MeshInstance3D] = [ $SegmentA, $SegmentB, $SegmentC, $SegmentD, $SegmentE, $SegmentF, $SegmentG ]


const DIGITS : Array[int] = [ 63, 6, 91, 79, 102, 109, 125, 7, 127, 111 ]


@export var value : int = 0:
	get:
		return value
	set(v):
		value = v
		show_number(value)

func _ready():
	show_number(value)

func show_number(v : int):
	if not is_inside_tree():
		return
	var mask = DIGITS[v]
	for i in range(7):
		segments[i].visible = (mask & 1 == 1)
		mask >>= 1
