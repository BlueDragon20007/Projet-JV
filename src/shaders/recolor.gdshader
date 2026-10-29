shader_type canvas_item;

// --- COULEURS CIBLES ---
uniform vec4 target_hair : source_color = vec4(0.35, 0.2, 0.1, 1.0);
uniform vec4 target_shirt : source_color = vec4(0.8, 0.2, 0.2, 1.0);
uniform vec4 target_pants : source_color = vec4(0.15, 0.2, 0.35, 1.0);

// --- TABLEAUX DE NUANCES ---
uniform vec4 shirt_colors[6] : source_color;
uniform vec4 pants_colors[6] : source_color;
uniform vec4 hair_colors[6] : source_color;

const float THRESHOLD = 0.03;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (tex.a < 0.01) {
		COLOR = tex;
	} else {
		vec3 rgb = tex.rgb;
		float lum = dot(rgb, vec3(0.299, 0.587, 0.114));
		
		bool is_shirt = false;
		bool is_pants = false;
		bool is_hair = false;

		for (int i = 0; i < 6; i++) {
			if (shirt_colors[i].a > 0.01 && distance(rgb, shirt_colors[i].rgb) < THRESHOLD) {
				is_shirt = true;
				break;
			}
		}

		if (!is_shirt) {
			for (int i = 0; i < 6; i++) {
				if (pants_colors[i].a > 0.01 && distance(rgb, pants_colors[i].rgb) < THRESHOLD) {
					is_pants = true;
					break;
				}
			}
		}

		if (!is_shirt && !is_pants) {
			for (int i = 0; i < 6; i++) {
				if (hair_colors[i].a > 0.01 && distance(rgb, hair_colors[i].rgb) < THRESHOLD) {
					is_hair = true;
					break;
				}
			}
		}

		if (is_shirt) {
			COLOR = vec4(target_shirt.rgb * (lum * 1.45), tex.a);
		} else if (is_pants) {
			COLOR = vec4(target_pants.rgb * (lum * 1.55), tex.a);
		} else if (is_hair) {
			COLOR = vec4(target_hair.rgb * (lum * 1.5), tex.a);
		} else {
			COLOR = tex;
		}
	}
}