class_name HostCivilian
extends Host

@export var civilian_skins: Array[Texture2D] = []

@export var hair_colors: Array[Color] = [
	Color("2c1b18"),
	Color("5a3825"),
	Color("a26c47"),
	Color("d8a35d"),
	Color("a84323"),
	Color("dcdde1")
]

@export var shirt_colors: Array[Color] = [
	Color("e74c3c"),
	Color("3498db"),
	Color("2ecc71"),
	Color("9b59b6"),
	Color("e67e22"),
	Color("f1c40f")
]

@export var pants_colors: Array[Color] = [
	Color("2c3e50"),
	Color("7f8c8d"),
	Color("16a085"),
	Color("8e44ad"),
	Color("34495e")
]

func _ready() -> void:
	super()
	apply_random_skin()
	apply_random_colors()

func apply_random_skin() -> void:
	if civilian_skins.size() > 0:
		sprite.texture = civilian_skins.pick_random()

func apply_random_colors() -> void:
	if sprite.material is ShaderMaterial:
		var mat: ShaderMaterial = sprite.material.duplicate()

		if hair_colors.size() > 0:
			mat.set_shader_parameter("target_hair", hair_colors.pick_random())

		if shirt_colors.size() > 0:
			mat.set_shader_parameter("target_shirt", shirt_colors.pick_random())

		if pants_colors.size() > 0:
			mat.set_shader_parameter("target_pants", pants_colors.pick_random())

		sprite.material = mat
