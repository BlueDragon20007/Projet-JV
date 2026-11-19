class_name BuilderGenerator
extends Node2D

@export var tile_map_layer: TileMapLayer
@export var source_id: int = 0

var building_styles: Dictionary = {
	"brick": {
		"has_borders": true,
		"block_size": Vector2i(2, 2),
		"left_offset": Vector2i(-2, 0),
		"right_offset": Vector2i(2, 0),
		"roof_offset": Vector2i(-1, -1),
		"door_offset": Vector2i(10, -2)
	},
	"glass": {
		"has_borders": false,
		"block_size": Vector2i(2, 4),
		"door_offset": Vector2i(-4, 0)
	}
}

var building_textures: Dictionary = {
	"brick": {
		"dark": Vector2i(32, 2),
		"pale": Vector2i(32, 6)
	},
	"glass": {
		"blue": Vector2i(10, 0),
	}
}

const ground_level := 22

func _ready() -> void:
	#seed(123456)
	var start_cell = Vector2i(5, ground_level)
	generate_city(start_cell, 40, 2)

func generate_city(start_pos: Vector2i, total_distance: int, spacing: int):
	var current_x = start_pos.x
	var distance_covered = 0
	
	while distance_covered < total_distance:
		var style_name = ["brick", "glass"].pick_random()
		var width = randi_range(3, 5) * 2
		var floors = randi_range(2, 5)
		
		var tile: Vector2i
		if style_name == "brick":
			tile = building_textures["brick"].values().pick_random()
		else:
			tile = building_textures["glass"]["blue"]
		
		var building_pos = Vector2i(current_x, start_pos.y)
		generate_building(building_pos, width, floors, style_name, tile)
		
		current_x += width + spacing
		distance_covered += width + spacing

func generate_building(start_pos: Vector2i, total_width_units: int, total_floors: int, style_name: String, base_atlas_pos: Vector2i):
	var style = building_styles.get(style_name, building_styles["brick"])
	var b_size: Vector2i = style["block_size"]
	var has_borders: bool = style["has_borders"]
	
	const floor_height := 4
	
	for floor_idx in range(total_floors):
		var floor_base_y = start_pos.y - (floor_idx * floor_height) - b_size.y
		var is_top_floor = (floor_idx == total_floors - 1)
		
		var rows_per_floor = floor_height / b_size.y
		
		for r in range(rows_per_floor):
			var current_y = floor_base_y - (r * b_size.y)
			var is_top_row = (r == rows_per_floor - 1)
			
			var x_unit = 0
			while x_unit < total_width_units:
				#await get_tree().create_timer(0.1).timeout
				var cell_pos = Vector2i(start_pos.x + x_unit, current_y)
					
				if has_borders and x_unit == 0:
					_place_single_block(cell_pos, base_atlas_pos + style["left_offset"], b_size)
				elif has_borders and x_unit >= total_width_units - b_size.x:
					_place_single_block(cell_pos, base_atlas_pos + style["right_offset"], b_size)
				else:
					_place_single_block(cell_pos, base_atlas_pos, b_size)
					
				x_unit += b_size.x
	
	if style_name == "brick" and "roof_offset" in style:
		var roof_y = start_pos.y - (total_floors * floor_height)
		var roof_x = 0
		
		while roof_x < total_width_units:
			var roof_pos = Vector2i(start_pos.x + roof_x, roof_y)
			_place_single_block(roof_pos, base_atlas_pos + style["roof_offset"], Vector2i(b_size.x, 1))
			roof_x += b_size.x
	
	place_door(start_pos + Vector2i(2, -1), base_atlas_pos + style["door_offset"])

func _place_single_block(origin: Vector2i, tile_coord: Vector2i, size: Vector2i) -> void:
	for y in range(size.y):
		for x in range(size.x):
			var target_pos = origin + Vector2i(x, y)
			tile_map_layer.set_cell(target_pos, source_id, tile_coord + Vector2i(x, y))

func place_door(position : Vector2i, tile : Vector2i):
	for i in 2:
		for j in 4:
			var target_pos = position + Vector2i(i, -j)
			tile_map_layer.set_cell(target_pos, source_id, tile + Vector2i(i, 3 - j))
