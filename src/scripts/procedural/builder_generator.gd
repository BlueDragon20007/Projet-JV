class_name BuilderGenerator
extends Node2D

@export var tile_map_layer: TileMapLayer
@export var source_id: int = 0
@export var min_spacing: int = 1
@export var max_spacing: int = 3
@export var windows_on_ground_floor: bool = true
@export var window_vertical_offset: int = 1
@export var window_spacing: int = 1

var building_styles: Dictionary = {
	"brick": {
		"has_borders": true,
		"block_size": Vector2i(2, 2),
		"left_offset": Vector2i(-2, 0),
		"right_offset": Vector2i(2, 0),
		"roof_offset": Vector2i(-1, -1),
		"door_offset": Vector2i(10, -2),
		"window_top_offset": Vector2i(-6, -2),
		"window_bottom_offset": Vector2i(-6, 1)
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
	var start_cell = Vector2i(2, ground_level)
	generate_city(start_cell, 40, min_spacing, max_spacing)

func generate_city(start_pos: Vector2i, total_distance: int, min_dist: int = 1, max_dist: int = 3):
	var current_x = start_pos.x
	var distance_covered = 0
	
	while distance_covered < total_distance:
		var style_name = ["brick", "glass"].pick_random()
		var width = randi_range(5, 7) * 2
		var floors = randi_range(2, 5)
			
		var tile: Vector2i
		if style_name == "brick":
			tile = building_textures["brick"].values().pick_random()
		else:
			tile = building_textures["glass"]["blue"]
		
		var building_pos = Vector2i(current_x, start_pos.y)
		generate_building(building_pos, width, floors, style_name, tile)
		
		var spacing = randi_range(min_dist, max_dist)
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
		var roof_y = start_pos.y - (total_floors * floor_height) - 1
		var roof_x = 0
		
		while roof_x < total_width_units:
			var roof_pos = Vector2i(start_pos.x + roof_x, roof_y)
			_place_single_block(roof_pos, base_atlas_pos + style["roof_offset"], Vector2i(b_size.x, 1))
			roof_x += b_size.x
	
	# Position aléatoire de la porte sur la largeur
	var min_door_x = b_size.x if has_borders else 0
	var max_door_x = total_width_units - 2 - (b_size.x if has_borders else 0)
	var valid_door_xs: Array[int] = []
	for dx in range(min_door_x, max_door_x + 1, 2):
		valid_door_xs.append(dx)
	var door_x: int = valid_door_xs.pick_random() if not valid_door_xs.is_empty() else min_door_x

	# Placement des fenêtres 2x2 centrées pour les bâtiments en brique
	if style_name == "brick" and "window_top_offset" in style and "window_bottom_offset" in style:
		var top_atlas = base_atlas_pos + style["window_top_offset"]
		var bottom_atlas = base_atlas_pos + style["window_bottom_offset"]
		var interior_start = b_size.x if has_borders else 0
		var interior_width = total_width_units - (b_size.x * 2 if has_borders else 0)
		const win_w := 2
		var min_gap = maxi(1, window_spacing)
		var win_count = (interior_width + min_gap) / (win_w + min_gap) if interior_width >= win_w else 0

		if win_count > 0:
			var win_xs: Array[int] = []
			if win_count == 1:
				win_xs.append(interior_start + (interior_width - win_w) / 2)
			else:
				var gap = (interior_width - win_count * win_w) / (win_count - 1)
				var group_width = win_count * win_w + (win_count - 1) * gap
				var left_margin = (interior_width - group_width) / 2
				for i in range(win_count):
					win_xs.append(interior_start + left_margin + i * (win_w + gap))

			var start_floor = 0 if windows_on_ground_floor else 1
			for floor_idx in range(start_floor, total_floors):
				var floor_top_y = start_pos.y - ((floor_idx + 1) * floor_height)
				var win_top_y = floor_top_y + window_vertical_offset
				for x_unit in win_xs:
					var overlaps_door = (floor_idx == 0 and x_unit + 1 >= door_x and x_unit <= door_x + 1)
					if not overlaps_door:
						place_window(Vector2i(start_pos.x + x_unit, win_top_y), top_atlas, bottom_atlas)
	
	place_door(start_pos + Vector2i(door_x, -1), base_atlas_pos + style["door_offset"])

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

func place_window(position: Vector2i, top_atlas: Vector2i, bottom_atlas: Vector2i) -> void:
	for x in 2:
		tile_map_layer.set_cell(position + Vector2i(x, 0), source_id, top_atlas + Vector2i(x, 0))
		tile_map_layer.set_cell(position + Vector2i(x, 1), source_id, bottom_atlas + Vector2i(x, 0))
