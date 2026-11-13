class_name CinematicTransition
extends Control

@export_file("*.tscn") var next_scene_path: String = ""
@export var video_stream: VideoStream

@onready var video_player: VideoStreamPlayer = $AspectRatioContainer/VideoPlayer
@onready var skip_button: Button = $SkipButton

var _is_transitioning: bool = false

func _ready() -> void:
	if video_stream:
		video_player.stream = video_stream

	video_player.finished.connect(_on_video_finished)

	if video_player.stream != null:
		video_player.play()
	else:
		end_cutscene()

func _on_video_finished() -> void:
	end_cutscene()

func end_cutscene() -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	video_player.stop()

	if next_scene_path.is_empty():
		return
