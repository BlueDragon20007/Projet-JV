class_name HostShoot
extends HostBaseState

const AIM_TIME = 1.0
var aim_timer = 0.0

func enter() -> void:
	host.animation_player.play("shoot")
	aim_timer = AIM_TIME
	host.velocity.x = 0.0

func physics_update(delta: float) -> void:
	var parasite = host._visible_parasite()
	
	if parasite == null:
		Transitioned.emit(self, "idle")
		return
	
	aim_timer -= delta
	
	if aim_timer <= 0.0:
		parasite.die()
