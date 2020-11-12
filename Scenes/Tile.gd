tool
extends StaticBody

export var type:String setget set_type

var bSelected = false

var free_distance_threshold_lr = 0.5
var free_distance_threshold_ud = 0.4
var free_distance_threshold_topside = 1.0

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
		tile_left = tile_left or (dir_collision.z < -free_distance_threshold_lr and abs(dir_collision.y) < free_distance_threshold_ud)
		tile_right = tile_right or (dir_collision.z > free_distance_threshold_lr and abs(dir_collision.y) < free_distance_threshold_ud)
		tile_top = tile_top or (dir_collision.y > free_distance_threshold_ud and abs(dir_collision.z) < free_distance_threshold_topside)
		#print(dir_collision)
		#print("Tile Top: "+str(tile_top))
		#print("Tile Left: "+str(tile_left))
		#print("Tile Right: "+str(tile_right))
	return !tile_top && (!tile_left or !tile_right)
	pass

func on_clicked():
	if (is_free()):
		$"/root/Board/Controls".tile_clicked(self)
	else:
		$AnimationPlayer.play("NotFree")
		$"/root/Board/Controls".tile_not_free_clicked(self)
	pass

func selected():
	$AnimationPlayer.play("Selected")
	bSelected = true

func deselected():
	$AnimationPlayer.seek(0,true)
	$AnimationPlayer.stop(true)
	bSelected = false

func remove():
	queue_free()

func set_type(t):
	type = t
	set_texture(t)

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
