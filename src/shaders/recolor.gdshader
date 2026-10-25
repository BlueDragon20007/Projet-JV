shader_type canvas_item;

// --- COULEURS CIBLES (injectées par GDScript) ---
uniform vec4 target_hair : source_color = vec4(0.35, 0.2, 0.1, 1.0);
uniform vec4 target_shirt : source_color = vec4(0.8, 0.2, 0.2, 1.0);
uniform vec4 target_pants : source_color = vec4(0.15, 0.2, 0.35, 1.0);

// --- COULEURS EXACTES DU CHANDAIL (5 nuances) ---
uniform vec4 shirt_0 : source_color;
uniform vec4 shirt_1 : source_color;
uniform vec4 shirt_2 : source_color;
uniform vec4 shirt_3 : source_color;
uniform vec4 shirt_4 : source_color;
uniform vec4 shirt_5 : source_color;

// --- COULEURS EXACTES DU PANTALON (5 nuances) ---
uniform vec4 pants_0 : source_color;
uniform vec4 pants_1 : source_color;
uniform vec4 pants_2 : source_color;
uniform vec4 pants_3 : source_color;
uniform vec4 pants_4 : source_color;

// --- COULEURS EXACTES DES CHEVEUX (5 nuances) ---
uniform vec4 hair_0 : source_color;
uniform vec4 hair_1 : source_color;
uniform vec4 hair_2 : source_color;
uniform vec4 hair_3 : source_color;
uniform vec4 hair_4 : source_color;
uniform vec4 hair_5 : source_color;

const float THRESHOLD = 0.03;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (tex.a < 0.01) {
		COLOR = tex;
	} else {
		vec3 rgb = tex.rgb;
		float lum = dot(rgb, vec3(0.299, 0.587, 0.114));

		// 1. Test Chandail
		if (distance(rgb, shirt_0.rgb) < THRESHOLD ||
			distance(rgb, shirt_1.rgb) < THRESHOLD ||
			distance(rgb, shirt_2.rgb) < THRESHOLD ||
			distance(rgb, shirt_3.rgb) < THRESHOLD ||
			distance(rgb, shirt_4.rgb) < THRESHOLD) {
			COLOR = vec4(target_shirt.rgb * (lum * 1.45), tex.a);
		}
		// 2. Test Pantalon
		else if (distance(rgb, pants_0.rgb) < THRESHOLD ||
			distance(rgb, pants_1.rgb) < THRESHOLD ||
			distance(rgb, pants_2.rgb) < THRESHOLD ||
			distance(rgb, pants_3.rgb) < THRESHOLD ||
			distance(rgb, pants_4.rgb) < THRESHOLD) {
			COLOR = vec4(target_pants.rgb * (lum * 1.55), tex.a);
		}
		// 3. Test Cheveux
		else if (distance(rgb, hair_0.rgb) < THRESHOLD ||
			distance(rgb, hair_1.rgb) < THRESHOLD ||
			distance(rgb, hair_2.rgb) < THRESHOLD ||
			distance(rgb, hair_3.rgb) < THRESHOLD ||
			distance(rgb, hair_4.rgb) < THRESHOLD ||
			distance(rgb, hair_5.rgb) < THRESHOLD) {
			COLOR = vec4(target_hair.rgb * (lum * 1.5), tex.a);
		}
		// Reste intact
		else {
			COLOR = tex;
		}
	}
}