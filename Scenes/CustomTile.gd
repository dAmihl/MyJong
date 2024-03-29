extends "Tile.gd"

func _ready():
	set_custom_texture(type)

func set_texture(t):
	.set_texture(t)
	set_custom_texture(t)

func set_type(t):
	.set_type(t)
	set_custom_texture(t)

func set_custom_texture(t):
	if !has_node("MeshGroup"):
		return
	var customBgPath = TileType.type_custombg_path(t)
	if customBgPath:
		var tex = load(customBgPath)
		var custom_mat:ShaderMaterial = load("res://Shader/tile_customtex_shadermat.tres").duplicate()
		#custom_mat.albedo_texture = tex
		custom_mat.set_shader_param("tex", tex)
		$MeshGroup/Tile.set_surface_material(0, custom_mat)
