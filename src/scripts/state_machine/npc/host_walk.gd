class_name HostWalk
extends HostBaseState

var base_position := 0
var target_x := 0

const MAX_DISTANCE := 200.0
const ARRIVAL_DIST: float = 4.0

func enter():
	host.animation_player.play("walk")
	base_position = host.position.x
	var offset: float = randf_range(-MAX_DISTANCE, MAX_DISTANCE)
	target_x = host.position.x + offset


func physics_update(delta: float) -> void:
	var distance_x := target_x - host.position.x
	if abs(distance_x) <= ARRIVAL_DIST:
		host.velocity.x = 0
		Transitioned.emit(self, "idle")
		return
		
	var direction = sign(distance_x)
	apply_horizontal_movement(direction)
	
