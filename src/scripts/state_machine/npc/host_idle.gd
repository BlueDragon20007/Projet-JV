class_name HostIdle
extends HostBaseState

var base_position := 0.0
var target_x := 0.0
var wait_timer := 0.0

const MAX_DISTANCE := 200.0
const ARRIVAL_DIST: float = 4.0

func enter():
	host.animation_player.play("idle")
	wait_timer = randf_range(1, 5)

func physics_update(delta: float) -> void:
	wait_timer -= delta
	if wait_timer <= 0:
		Transitioned.emit(self, "walk")
