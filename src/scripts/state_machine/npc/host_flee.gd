class_name HostFlee
extends HostBaseState

var base_position := 0
var target_x := 0

const MIN_DISTANCE := 20.0
const MAX_DISTANCE := 200.0
const ARRIVAL_DIST: float = 4.0

func enter():
	host.animation_player.play("run")
	base_position = host.position.x
	var offset: float = 0.0
	
	if host.ray.is_colliding():
		host.sprite.scale.x = -host.sprite.scale.x
		
		offset = randf_range(MIN_DISTANCE, MAX_DISTANCE) * host.sprite.scale.x
	else:
		offset = randf_range(-MAX_DISTANCE, MAX_DISTANCE)
		
	target_x = host.position.x + offset


func physics_update(delta: float) -> void:
	if host.ray.is_colliding():
		host.velocity.x = 0
		Transitioned.emit(self, "idle")
		return
		
	var distance_x := target_x - host.position.x
	if abs(distance_x) <= ARRIVAL_DIST:
		host.velocity.x = 0
		Transitioned.emit(self, "idle")
		return
		
	var direction = sign(distance_x)
	apply_horizontal_movement(direction)
	
