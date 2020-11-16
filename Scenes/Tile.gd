tool
extends StaticBody

export var type:String setget set_type

var bSelected = false

var free_distance_threshold_lr = 0.5
var free_distance_threshold_below = 0.3
var free_distance_threshold_above = 0.4
var free_distance_threshold_topside = 0.8

var layer:int = 0 setget set_layer

signal tile_clicked
signal tile_not_free_clicked

func _ready():
	set_texture(type)
	pass

func is_free() -> bool:
	var overlap = $Area.get_overlapping_bodies()
	var tile_left:bool = false
	var tile_right:bool = false
	var tile_top:bool = false
	for collider in overlap:
		if collider==self:
			continue
		var dir_collision = self.translation.direction_to(collider.translation)
		tile_left = tile_left or (dir_collision.z < -free_distance_threshold_lr and abs(dir_collision.y) < free_distance_threshold_below)
		tile_right = tile_right or (dir_collision.z > free_distance_threshold_lr and abs(dir_collision.y) < free_distance_threshold_below)
		tile_top = tile_top or (dir_collision.y > free_distance_threshold_above and abs(dir_collision.z) <= free_distance_threshold_topside)
		#print(dir_collision)
		#print("Tile Top: "+str(tile_top))
		#print("Tile Left: "+str(tile_left))
		#print("Tile Right: "+str(tile_right))
	return !tile_top && (!tile_left or !tile_right)
	pass

func on_clicked():
	if (is_free()):
		emit_signal("tile_clicked", self)
		#$"/root/Board/Controls".tile_clicked(self)
	else:
		$AnimationPlayer.play("NotFree")
		emit_signal("tile_not_free_clicked", self)
		#$"/root/Board/Controls".tile_not_free_clicked(self)
	pass

func selected():
	$AnimationPlayer.play("Selected")
	bSelected = true

func deselected():
	$AnimationPlayer.seek(0,true)
	$AnimationPlayer.stop(true)
	bSelected = false

func remove():
	deselected()
	get_parent().remove_child(self)

func set_type(t):
	type = t
	set_texture(t)

func set_layer(layerNum:int):
	layer = layerNum

func set_layer_mat_color(numLayers:int):
	var layerAlbedof = (float(layer)/float(numLayers)) * 0.3
	layerAlbedof += 0.7
	layerAlbedof = 1 - float(numLayers - layer)/20.0
	var col:Color = Color(layerAlbedof, layerAlbedof, layerAlbedof, 1.0)
	$MeshGroup/Tile.get_active_material(0).albedo_color = col
	$MeshGroup/Symbol.modulate = col

func set_texture(t):
	var tex_path = TileType.type_texture_path(t)
	if !has_node("MeshGroup"):
		return
	$MeshGroup/Symbol.texture = load(tex_path)

func _on_Tile_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		on_clicked()
	pass # Replace with function body.

func hint_highlight():
	$AnimationPlayer.play("HintHighlight")
	yield(get_tree().create_timer(1.0), "timeout")
	$AnimationPlayer.seek(0,true)
	$AnimationPlayer.stop()

func add_outline():
	$MeshGroup/Tile/Outline.get_active_material(0).albedo_color = Color.lightgreen
	pass

func remove_outline():
	$MeshGroup/Tile/Outline.get_active_material(0).albedo_color = Color.black
	pass

func _on_Tile_mouse_entered():
	if is_free():
		add_outline()
	pass # Replace with function body.


func _on_Tile_mouse_exited():
	remove_outline()
	pass # Replace with function body.
