extends Spatial

#var block_scn = preload("res://Scenes/CustomTile.tscn")
var block_scn = preload("res://Scenes/Tile.tscn")

var tile_width:float = 2.2
var tile_height:float = 3.6
var tile_depth:float = 1.1

var layout = []
var rngseed = 4242
export var fixed_rngseed = 7715046466232329341
export var use_seed:bool = true

export var layout_json_name:String = "turtle.json"

onready var RNG = RandomNumberGenerator.new()
onready var gameboard = $"/root/Board/GameBoard"

signal restart_done

func load_json():
	var file = File.new()
	file.open("res://layout/"+layout_json_name, file.READ)
	var text_json = file.get_as_text()
	var result_json = JSON.parse(text_json)
	var result = {}

	if result_json.error == OK:  # If parse OK
		var data = result_json.result
		layout = data
		draw_layout()
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO RAND SEED
	RNG.randomize()
	rngseed = RNG.seed
	if use_seed:
		rngseed = fixed_rngseed #unsolvable?
	print("Seed:"+str(rngseed))
	load_json()
	pass # Replace with function body.

func draw_layout():
	#distribute_random()
	RNG.seed = rngseed
	distribute_random_solvable()
	gameboard.board_ready()
	return
	
func draw_tile(pos, layerNum, type):
	var new_tile = block_scn.instance()
	var pos_x:float = (pos[0] * tile_height)
	var pos_z:float = (pos[1] * tile_width)
	var pos_y = layerNum * tile_depth
	new_tile.translation = Vector3(pos_x, pos_y, pos_z)
	new_tile.set_type(type)
	gameboard.add_tile(new_tile, pos, 0)
	
func distribute_random():
	var typeNumberTmp = TileType.TypeNumber.duplicate(true)
	var layoutTmp = layout.duplicate(true)
	var current_layer = 0

	while(typeNumberTmp.size() > 0 && current_layer < layoutTmp.size()):
		#pick a type
		var ixType = RNG.randi() % typeNumberTmp.keys().size()
		var type = typeNumberTmp.keys()[ixType]
		var numType = typeNumberTmp[type]
		
		var bPairwise = numType > 1
		var num_blocks = 1
		if bPairwise:
			num_blocks = 2
		
		# pick random pos
		for i in range(0,num_blocks):
			# if the layer is full, go to next
			if layoutTmp[current_layer].size() == 0: # all positions used
				current_layer += 1
				if current_layer >= layoutTmp.size():
					break
			var pos_idx = RNG.randi() % layoutTmp[current_layer].size()
			var pos = layoutTmp[current_layer][pos_idx]
			layoutTmp[current_layer].erase(pos)
			draw_tile(pos, current_layer,type)
		
		typeNumberTmp[type] -= num_blocks
		if typeNumberTmp[type] <= 0:
			typeNumberTmp.erase(type)
	pass
	
func distribute_random_solvable():
	var typeNumberTmp = TileType.TypeNumber.duplicate(true)
	var layoutTmp = layout.duplicate(true)
	var current_layer = 0
	
	# While there are tile types left and we dont overshoot the available layers..
	while(typeNumberTmp.size() > 0 && current_layer < layoutTmp.size()):
		# (1) pick a remaining random type at random
		var ixType = RNG.randi() % typeNumberTmp.keys().size()
		var type = typeNumberTmp.keys()[ixType]
		var numType = typeNumberTmp[type]
		
		# Pairwise means the tile type has a pair of the exact same type
		# if not pairwise, then the tile is in a group
		# we then have to choose a new type from the same group for the 2nd
		# tile
		var typeGrouped = numType % 2 == 1
		var previous_chosen_edge
		var previous_chosen_layer
	
		# Do this for the amount of blocks we need: always pairwise
		for nBlock in range(0, 2):
			
			# (1.5) Choose layer at random from all with space
			# Get all layers with space
			var available_layers = []
			for layerIdx in range(0,layoutTmp.size()):
				if layoutTmp[layerIdx].size() > 0:
					available_layers.append(layerIdx)
			# Choose layer to work on
			if available_layers.size() == 0:
				# No layers available
				return
			
			var edges = []
			while (edges.empty() and available_layers.size() > 0):
				var chosen_layer = available_layers[RNG.randi()%available_layers.size()]
			
				var layer_switch:bool = nBlock > 0 and chosen_layer != current_layer
				if nBlock > 0:
					previous_chosen_layer = current_layer
				else:
					previous_chosen_layer = null
				current_layer = chosen_layer
			
				# (2) Choose random row on current layer
				var rows = layoutTmp[current_layer]
				var available_rows = []
				for pos in rows:
					if !available_rows.has(pos[0]):
						available_rows.append(pos[0])
				
				var chosen_row = available_rows[RNG.randi() % available_rows.size()]
				
				if type == "Man3":
					pass
				
				# (3) Get edges on chosen row, including half-steps (+- 0.5).
				# Edge is a pos which has either nothing left or right
				# (+) and has tiles on bottom
				
				for pos1 in rows:
					if abs(pos1[0] - chosen_row) >= 1:
						continue
					var is_edge:bool = true
					var left_neighbour_found:bool = false
					var right_neighbour_found:bool = false
					
					for pos2 in rows:
						if pos1 == pos2:
							continue
						if abs(pos2[0] - chosen_row) >= 1:
							continue
						if left_neighbour_found and right_neighbour_found:
							is_edge = false
							break
						if pos1[1] == pos2[1] - 1:
							# there is a position right to pos1
							right_neighbour_found = true
							continue
						if pos1[1] == pos2[1] + 1:
							left_neighbour_found = true
							continue
						# If there is a layer switch, keep the distance to
						# the previous chosen edge
						if layer_switch and abs(previous_chosen_edge[1] - pos1[1]) < 1:
							is_edge = false
							break
					if left_neighbour_found and right_neighbour_found:
						is_edge = false
						
					# (+) Check if tile has tiles on top if it is on lower layer.
					# !! we are not building inside out, but outside in!!!
					if is_edge and current_layer < layoutTmp.size()-1:
						var higher_layer = current_layer + 1
						var has_tile_on_top = false
						# the idea:
						# if there is a free tile on a higher layer, which is less
						# than a halfstep away (so would be blocked by this tile),
						# then dont count this tile as available edge
						for t in layoutTmp[higher_layer]:
							var delta_dist_x = abs(pos1[0] - t[0])
							var delta_dist_y = abs(pos1[1] - t[1])
							# only count tiles at least halfsteps away
							if delta_dist_x <= 0.5 and delta_dist_y <= 0.5:
								is_edge = false
								break
					if is_edge:
						edges.append(pos1)
				
				if edges.size() == 0:
					available_layers.erase(current_layer)
			
			if edges.size() == 0 and available_layers.size() == 0:
				print("ERROR!! NO EDGES! NO LAYERS LEFT! Something went terribly wrong")
				return
			
			if edges.size() > 1:
				for e in edges:
					# if the second block is next to the previous chosen one
					# dont use that; except its the only one
					if nBlock > 0 and previous_chosen_layer == current_layer:
						var delta_dist_x = abs(e[0] - previous_chosen_edge[0])
						var delta_dist_y = abs(e[1] - previous_chosen_edge[1])
						if (delta_dist_x <= 1.0 and
							delta_dist_y <= 1.0 
							and not (delta_dist_x == 1.0 and delta_dist_y == 1.0)):
								edges.erase(e)
			
			# (4) Choose random edge
			var chosen_edge = edges[RNG.randi() % edges.size()]
			previous_chosen_edge = chosen_edge
			
			# (5) Remove both pos from layout
			layoutTmp[current_layer].erase(chosen_edge)
			
			typeNumberTmp[type] -= 1
			if typeNumberTmp[type] <= 0:
				typeNumberTmp.erase(type)
			
			# (6) Draw Tile 
			draw_tile(chosen_edge, current_layer,type)
			
			# (7) If the Tile is in a group and has not another tile from the
			# same type, we have to choose a tile from the same group for the 
			# second tile
			if (nBlock == 0 and typeGrouped):
				# we choose the next tile in after the first tile
				var second_types = TileType.get_types_from_same_group(type)
				var available_second_types = []
				for st in second_types:
					if typeNumberTmp.has(st):
						available_second_types.append(st)
				if available_second_types.empty():
					print("No other Type in Group found!!")
					return
				# now choose next type as random type from list
				type = available_second_types[randi()%available_second_types.size()]
	
	print("Generate finished")
	pass


func try_solve_bruteforce():
	var num_tries = 100
	var solved = false
	for i in range(0, num_tries):
		randomize()
		call_deferred("restart")
		yield(self, "restart_done")
		yield(get_tree().create_timer(1.0), "timeout")
		while gameboard.board.size() > 0:
			var hint = gameboard.get_random_hint()
			#hint = gameboard.get_smart_hint()
			if hint.empty():
				break
			else:
				var b = hint[0]
				var b2 = hint[1]
				$"../Controls".remove_block(b)
				$"../Controls".remove_block(b2)
			yield(get_tree().create_timer(0.1), "timeout")
		if gameboard.board.size() == 0:
			print("Solved!!")
			solved = true
			return
		else:
			print("Not solved this time. Trying again!")
	pass
	
func restart():
	gameboard.call_deferred("clear")
	yield(gameboard, "clear_done")
	load_json()
	emit_signal("restart_done")
