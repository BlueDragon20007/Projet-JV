class_name DebugOverlay
extends CanvasLayer

@onready var stats_label: Label = $PanelContainer/StatsLabel

var debug_enabled: bool = false
var _min_mem_bytes: int = 0
var _max_mem_bytes: int = 0
var _has_mem_sample: bool = false

func _ready() -> void:
	visible = false

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug") and not event.is_echo():
		#_toggle_debug()
		#get_viewport().set_input_as_handled()

func _toggle_debug() -> void:
	debug_enabled = !debug_enabled
	visible = debug_enabled

	if debug_enabled:
		_update_memory_stats()
		_update_label()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		_toggle_debug()
	
	_update_memory_stats()
	_update_label()

func _update_memory_stats() -> void:
	var current := OS.get_static_memory_usage()
	if not _has_mem_sample:
		_min_mem_bytes = current
		_max_mem_bytes = current
		_has_mem_sample = true
	else:
		_min_mem_bytes = mini(_min_mem_bytes, current)
		_max_mem_bytes = maxi(_max_mem_bytes, current)

func _update_label() -> void:
	if stats_label == null:
		return
	var fps := Engine.get_frames_per_second()
	var cur_mb := _bytes_to_mb(OS.get_static_memory_usage())
	var min_mb := _bytes_to_mb(_min_mem_bytes)
	var max_mb := _bytes_to_mb(_max_mem_bytes)

	stats_label.text = (
		"DEBUG [F12]\n"
		+ "FPS: %d\n" % fps
		+ "RAM: %.2f MB\n" % cur_mb
		+ "(Min: %.2f MB | Max: %.2f MB)" % [min_mb, max_mb]
	)

func _bytes_to_mb(bytes_count: int) -> float:
	return float(bytes_count) / (1024.0 * 1024.0)
