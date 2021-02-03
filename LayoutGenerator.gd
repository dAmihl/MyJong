extends Spatial

#var block_scn = preload("res://Scenes/CustomTile.tscn")
var block_scn = preload("res://Scenes/Tile.tscn")

var tile_width:float = 2.2
var tile_height:float = 3.6
var tile_depth:float = 1.1

var layout = []
var rngseed = 4242
export var fixed_rngseed = -5352770736231847634
export var use_seed:bool = true

export var layout_json_name:String = "turtle.json"
export var highlight_free_tiles:bool = false

onready var RNG = RandomNumberGenerator.new()
onready var gameboard = $"../GameBoard"
onready var controls = $"../Controls"

signal restart_done

func load_layout():
	var layoutData = SceneManager.get_param("layout_data")
	if !layoutData and !is_instance_valid(layoutData):
		# default layout
		var layoutObj = LayoutManager.create_layout_from_file("res://layouts/", layout_json_name)
		if is_instance_valid(layoutObj):
			layout = layoutObj.layout_data
		else:
			print("Could not load fallback layout: "+str(layout_json_name))
	else:
		layout = layoutData
	
	var gamemode:GameModeManager.GameMode = SceneManager.get_param("gamemode")
	if (!gamemode and !is_instance_valid(gamemode)):
		print("Could not load game mode.")
		print("Assuming random.")
		gamemode = GameModeManager.createDefaultGamemode()
		draw_layout_random()
	elif gamemode.gamemode_gentype == gamemode.GenType.RANDOM:
		print("Mode Random.")
		draw_layout_random()
	elif gamemode.gamemode_gentype == gamemode.GenType.SOLVABLE:
		print("Mode Solvable")
		draw_layout_solvable()
	gameboard.set_gamemode(gamemode)

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO RAND SEED
	RNG.randomize()
	rngseed = RNG.seed
	if use_seed:
		rngseed = fixed_rngseed #unsolvable?
	print("Seed:"+str(rngseed))
	load_layout()
	pass # Replace with function body.

# Center the board via the number of cols and rows generated
func center_board_position():
	var num_rows_max = 0
	var num_cols_max = 0
	# defines the smallest row/col index. e.g. the smallest tile position
	var idx_rows_min = layout[0][0][0]
	var idx_cols_min = layout[0][0][1]
	
	for layer in layout:
		for tiles in layer:
			if tiles[1] > num_cols_max:
				num_cols_max = tiles[1]
			if tiles[0] > num_rows_max:
				num_rows_max = tiles[0]
			if tiles[0] < idx_rows_min:
				idx_rows_min = tiles[0]
			if tiles[1] < idx_cols_min:
				idx_cols_min = tiles[1]
	var pos_x = (float(num_rows_max+idx_rows_min) * tile_height) / 2.0
	var pos_z = (float(num_cols_max+idx_cols_min) * tile_width) / 2.0
	gameboard.translation.x = -pos_x
	gameboard.translation.z = -pos_z
	pass
	
func draw_layout_random():
	distribute_random()
	center_board_position()
	gameboard.board_ready()

func draw_layout_solvable():
	#distribute_random()
	var max_num_tries = 10
	var num_tries = 0
	var result:bool = true
	RNG.seed = rngseed
	while (distribute_random_solvable() == -1):
		num_tries += 1
		if num_tries >= max_num_tries:
			result = false
			break
		print("DistributeRandomSolvable failed. Trying new seed.")
		RNG.randomize()
		rngseed = RNG.seed
		print("New Seed: "+str(rngseed))
		gameboard.call_deferred("clear")
		yield(gameboard, "clear_done")
	if result:
		center_board_position()
		gameboard.board_ready()
	else:
		print("Could not generate a solvable distribution.")
		SceneManager.change_scene("Levels/LayoutList.tscn")
	return
	
func draw_tile(pos,  type):
	var new_tile = block_scn.instance()
	var layerNum = pos[2]
	var pos_x:float = (pos[0] * tile_height)
	var pos_z:float = (pos[1] * tile_width)
	var pos_y = layerNum * tile_depth
	new_tile.translation = Vector3(pos_x, pos_y, pos_z)
	new_tile.set_type(type)
	new_tile.set_layer(layerNum)
	new_tile.connect("tile_clicked", controls, "tile_clicked")
	new_tile.connect("tile_not_free_clicked", controls, "tile_not_free_clicked")
	new_tile.set_highlight_free(highlight_free_tiles)
	#var num_layers = layout.size()
	#new_tile.set_layer_mat_color(layout.size())
	gameboard.add_tile(new_tile)
	
func distribute_random():
	var typeNumberTmp = TileType.TypeNumber.duplicate(true)
	var layoutTmp = layout.duplicate(true)
	var current_layer = 0
	RNG.seed = rngseed
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
			draw_tile([pos[0], pos[1], current_layer],type)
		
		typeNumberTmp[type] -= num_blocks
		if typeNumberTmp[type] <= 0:
			typeNumberTmp.erase(type)
	return 0
	
func distribute_random_solvable():
	var typeNumberTmp = TileType.TypeNumber.duplicate(true)
	var layoutTmp = layout.duplicate(true)
	var current_layer = 0
	
	# While there are tile types left and we dont overshoot the available layers..
	while(typeNumberTmp.size() > 0):
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
			for chosen_layer in available_layers:
				#var chosen_layer = available_layers[RNG.randi()%available_layers.size()]
			
				if nBlock > 0:
					previous_chosen_layer = current_layer
				else:
					previous_chosen_layer = null
				current_layer = chosen_layer
				
				for pos1 in layoutTmp[current_layer]:
					var is_edge:bool = true
					var left_neighbour_found:bool = false
					var right_neighbour_found:bool = false
					
					# keep distance to previous chosen tile
					if nBlock > 0 and previous_chosen_edge:
						if (abs(pos1[0] - previous_chosen_edge[0]) < 1
						and abs(pos1[1] - previous_chosen_edge[1]) < 1):
							continue
					
					# find neighbours on current layer
					for pos2 in layoutTmp[current_layer]:
						if left_neighbour_found and right_neighbour_found:
							is_edge = false
							break
						if pos1 == pos2:
							continue
						if abs(pos2[0] - pos1[0]) >= 1:
							continue
						if pos1[1] == pos2[1] - 1:
							# there is a position right to pos1
							right_neighbour_found = true
							continue
						if pos1[1] == pos2[1] + 1:
							left_neighbour_found = true
							continue
						
					if left_neighbour_found and right_neighbour_found:
						is_edge = false 
						continue
						
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
						edges.append([pos1[0],pos1[1], current_layer])
			
			# Edges now consists of all edges on all layers
			if edges.size() > 1:
				for e in edges:
					# if the second block is next to the previous chosen one
					# dont use that; except its the only one
					if edges.size() == 1:
						break
					if nBlock > 0:
						var delta_dist_x = abs(e[0] - previous_chosen_edge[0])
						var delta_dist_y = abs(e[1] - previous_chosen_edge[1])
						var delta_dist_layer = abs(e[2] - previous_chosen_edge[2])
						if (delta_dist_x < 1.0 and
							delta_dist_y <= 1.0 
							and not (delta_dist_x == 1.0 and delta_dist_y == 1.0)
							and delta_dist_layer == 0):
								edges.erase(e)
				
			if edges.size() == 0:
				print("ERROR!! NO EDGES! NO LAYERS LEFT! Something went terribly wrong")
				return -1

			# (4) Choose random edge
			var chosen_edge = edges[RNG.randi() % edges.size()]
			previous_chosen_edge = chosen_edge
			
			# (5) Remove both pos from layout
			layoutTmp[chosen_edge[2]].erase([chosen_edge[0], chosen_edge[1]])
			
			typeNumberTmp[type] -= 1
			if typeNumberTmp[type] <= 0:
				typeNumberTmp.erase(type)
			
			# (6) Draw Tile 
			draw_tile(chosen_edge,type)
			
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
	return 0
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
			hint = gameboard.get_smart_hint()
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
	load_layout()
	emit_signal("restart_done")
