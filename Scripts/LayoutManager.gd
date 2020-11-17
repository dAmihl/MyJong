extends Node

const customLayoutDirPath:String = "user://layouts/"
const presetLayoutDirPath:String = "res://layouts/"

class Layout:
	
	var author:String = "default" setget set_author
	var layout_name:String = "Default Layout" setget set_layout_name
	var layout_full_path:String 
	var layout_data:Array setget set_layout_data
	
	func _init(vLayoutFullPath:String, vLayoutData:Array, 
		vAuthor:String = "default",  vLayoutName:String = "CustomLayout"):
		
		author = vAuthor
		layout_name = vLayoutName
		layout_full_path = vLayoutFullPath
		layout_data = vLayoutData
		pass
	
	func set_author(a:String):
		author = a
		
	func set_layout_name(ln:String):
		layout_name = ln
		
	func set_layout_data(ld:Array):
		layout_data = ld


func load_custom_layouts() -> Array:
	var custom_layouts = load_layouts(customLayoutDirPath)
	return custom_layouts
	
func load_preset_layouts() -> Array:
	var preset_layouts = load_layouts(presetLayoutDirPath)
	return preset_layouts
	
func load_workshop_layouts() -> Array:
	var workshop_layouts = []
	return workshop_layouts

# Load layouts from given root path
func load_layouts(rootPath:String) -> Array:
	var layouts = []
	var files = dir_contents(rootPath)
	if files.size() == 0:
		print("No Layouts found at "+str(rootPath)+".")
		return []
	
	for f in files:
		var new_layout = create_layout_from_file(rootPath, f)
		if is_instance_valid(new_layout):
			layouts.append(new_layout)
	return layouts

# Create Layout instances from files
func create_layout_from_file(filePath:String, fileName:String) -> Layout:
	var full_path = filePath+fileName
	return create_layout_from_fullpath(full_path)

func create_layout_from_fullpath(full_path:String) -> Layout:
	var data:Dictionary = parse_layout_json(full_path)
	if !data.has_all(["LayoutName", "LayoutData"]):
		print(str(full_path)+ " does not contain every information needed.")
		return null
	var author = data["Author"]
	var layoutName = data["LayoutName"]
	var layoutData = data["LayoutData"]
	var new_layout = Layout.new(full_path, layoutData, author, layoutName)
	return new_layout

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
	print(file.get_path())
	var text_json = file.get_as_text()
	var result_json:JSONParseResult = JSON.parse(text_json)
	var result:Dictionary = {}

	if result_json.error == OK and result_json.result is Dictionary:  # If parse OK
		result = result_json.result
	else:  # If parse has errors
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
	return result
