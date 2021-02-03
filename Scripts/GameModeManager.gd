extends Node

const customGamemodeDirPath:String = "user://gamemodes/"
const presetGamemodeDirPath:String = "res://gamemodes/"

############# CLASS GameMode ####################
class GameMode:
	
	#### CLASS GenType #####
	class GenType:
		const RANDOM = 0
		const SOLVABLE = 1
		
		func toString(gt:int):
			if gt == 0: 
				return "Random"
			elif gt == 1: 
				return "Solvable"
			else: 
				return "Unknown"
	#### CLASS END #####
	
	var author:String = "default" setget set_author
	
	var gamemode_name:String = "Default Gamemode" setget set_gamemode_name
	var gamemode_full_path:String 
	var gamemode_gentype: int = GenType.SOLVABLE setget set_gamemode_gentype
	
	var shuffle_cost: int = 0
	var undo_cost: int = 0
	var hint_cost: int = 0
	
	var hint_number: int = -1 # -1 = infinite
	var shuffle_number: int = -1 # -1 = infinite
	var undo_number: int = -1 # -1 = infinite
	
	func _init(vGameModeFullPath:String, vGenType:int, 
		vAuthor:String = "default",  vGameModeName:String = "Custom Gamemode",
		vShuffleCost:int = 0, vUndoCost:int = 0, vHintCost:int = 0,
		vHintNumber:int = 0, vShuffleNumber:int = 0, vUndoNumber:int = 0):
		
		author = vAuthor
		gamemode_name = vGameModeName
		gamemode_full_path = vGameModeFullPath
		gamemode_gentype = vGenType
		shuffle_cost = vShuffleCost
		undo_cost = vUndoCost
		hint_cost = vHintCost
		hint_number = vHintNumber
		shuffle_number = vShuffleNumber
		undo_number = vUndoNumber
		pass
	
	func set_author(a:String):
		author = a
		
	func set_gamemode_name(ln:String):
		gamemode_name = ln
		
	func set_gamemode_gentype(gt:int):
		gamemode_gentype = gt
		
	func to_dict_json() -> String:
		var dict:Dictionary = {}
		dict['Author'] = author
		dict['GamemodeName'] = gamemode_name
		dict['GamemodeGentype'] = gamemode_gentype
		dict['ShuffleCost'] = shuffle_cost
		dict['UndoCost'] = undo_cost
		dict['HintCost'] = hint_cost
		dict['HintNumber'] = hint_number
		dict['ShuffleNumber'] = shuffle_number
		dict['UndoNumber'] = undo_number
		
		return JSON.print(dict)

############# CLASS END ####################

func load_custom_gamemodes() -> Array:
	var custom_modes = load_gamemodes(customGamemodeDirPath)
	return custom_modes
	
func load_preset_gamemodes() -> Array:
	var preset_modes = load_gamemodes(presetGamemodeDirPath)
	return preset_modes
	
func load_workshop_gamemodes() -> Array:
	var workshop_modes = []
	return workshop_modes

# Load layouts from given root path
func load_gamemodes(rootPath:String) -> Array:
	var modes = []
	var files = dir_contents(rootPath)
	if files.size() == 0:
		print("No Gamemodes found at "+str(rootPath)+".")
		return []
	
	for f in files:
		var new_mode = create_gamemode_from_file(rootPath, f)
		if is_instance_valid(new_mode):
			modes.append(new_mode)
	return modes

# Create Layout instances from files
func create_gamemode_from_file(filePath:String, fileName:String) -> GameMode:
	var full_path = filePath+fileName
	return create_gamemode_from_fullpath(full_path)

func create_gamemode_from_fullpath(full_path:String) -> GameMode:
	var data:Dictionary = parse_layout_json(full_path)
	if !data.has_all(["GamemodeName", "GamemodeGenType"]):
		return null
	var author = data["Author"]
	var gamemodeName = data["GamemodeName"]
	var gamemodeGenType = data["GamemodeGenType"]
	var shuffle_cost = data["ShuffleCost"]
	var undo_cost = data["UndoCost"]
	var hint_cost = data["HintCost"]
	var hint_number = data["HintNumber"]
	var shuffle_number = data["ShuffleNumber"]
	var undo_number = data["UndoNumber"]
	var new_mode = GameMode.new(full_path, gamemodeGenType, author, gamemodeName,shuffle_cost, undo_cost, hint_cost, hint_number, shuffle_number, undo_number)
	return new_mode

# Load files from directory
func dir_contents(path) -> Array:
	var file_names = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				file_names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_names


# Parse Layout JSON
func parse_layout_json(layoutPath:String) -> Dictionary:
	var file = File.new()
	file.open(layoutPath, file.READ)
	var text_json = file.get_as_text()
	var result_json:JSONParseResult = JSON.parse(text_json)
	var result:Dictionary = {}

	if result_json.error == OK:
		if result_json.result is Dictionary:  # If parse OK
			result = result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
	return result

func createDefaultGamemode() -> GameMode:
	var newGm = GameMode.new("Default", GameMode.GenType.RANDOM, "Default", "Default") 
	return newGm
