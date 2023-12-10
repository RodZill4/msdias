extends Node3D


var time : int = 120


func _on_timer_timeout():
	time -= 1
	var tmp : int = time
	$SevenSegments4.value = tmp % 10
	tmp /= 10
	$SevenSegments3.value = tmp % 6
	tmp /= 6
	$SevenSegments2.value = tmp % 10
	tmp /= 10
	$SevenSegments1.value = tmp % 6
