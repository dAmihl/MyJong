class_name TileType

# Suits Dots
const Man1 = "Man1"
const Man2 = "Man2"
const Man3 = "Man3"
const Man4 = "Man4"
const Man5 = "Man5"
const Man6 = "Man6"
const Man7 = "Man7"
const Man8 = "Man8"
const Man9 = "Man9"
# Suits Characters
const Pin1 = "Pin1"
const Pin2 = "Pin2"
const Pin3 = "Pin3"
const Pin4 = "Pin4"
const Pin5 = "Pin5"
const Pin6 = "Pin6"
const Pin7 = "Pin7"
const Pin8 = "Pin8"
const Pin9 = "Pin9"
# Suits Bamboo
const Sou1 = "Sou1"
const Sou2 = "Sou2"
const Sou3 = "Sou3"
const Sou4 = "Sou4"
const Sou5 = "Sou5"
const Sou6 = "Sou6"
const Sou7 = "Sou7"
const Sou8 = "Sou8"
const Sou9 = "Sou9"
# Honors Winds
const Ton = "Ton"
const Nan = "Nan"
const Pei = "Pei"
const Shaa = "Shaa"
# Honors Dragons
const Chun = "Chun"
const Haku = "Haku"
const Hatsu = "Hatsu"
# Seasons (all 4 match)
const Seasons1 = "Seasons1"
const Seasons2 = "Seasons2"
const Seasons3 = "Seasons3"
const Seasons4 = "Seasons4"
# Flowers (all 4 match)
const Flowers1 = "Flowers1"
const Flowers2 = "Flowers2"
const Flowers3 = "Flowers3"
const Flowers4 = "Flowers4"

const TypeNumber = {
	Man1:4,
	Man2:4,
	Man3:4,
	Man4:4,
	Man5:4,
	Man6:4,
	Man7:4,
	Man8:4,
	Man9:4,

	Pin1:4,
	Pin2:4,
	Pin3:4,
	Pin4:4,
	Pin5:4,
	Pin6:4,
	Pin7:4,
	Pin8:4,
	Pin9:4,

	Sou1:4,
	Sou2:4,
	Sou3:4,
	Sou4:4,
	Sou5:4,
	Sou6:4,
	Sou7:4,
	Sou8:4,
	Sou9:4,

	Ton:4,
	Nan:4,
	Pei:4,
	Shaa:4,

	Chun:4,
	Haku:4,
	Hatsu:4,
	
	Seasons1:1,
	Seasons2:1,
	Seasons3:1,
	Seasons4:1,
	
	Flowers1:1,
	Flowers2:1,
	Flowers3:1,
	Flowers4:1,
}

const TypeTexture = {
	Man1:"Man1",
	Man2:"Man2",
	Man3:"Man3",
	Man4:"Man4",
	Man5:"Man5",
	Man6:"Man6",
	Man7:"Man7",
	Man8:"Man8",
	Man9:"Man9",

	Pin1:"Pin1",
	Pin2:"Pin2",
	Pin3:"Pin3",
	Pin4:"Pin4",
	Pin5:"Pin5",
	Pin6:"Pin6",
	Pin7:"Pin7",
	Pin8:"Pin8",
	Pin9:"Pin9",

	Sou1:"Sou1",
	Sou2:"Sou2",
	Sou3:"Sou3",
	Sou4:"Sou4",
	Sou5:"Sou5",
	Sou6:"Sou6",
	Sou7:"Sou7",
	Sou8:"Sou8",
	Sou9:"Sou9",

	Ton:"Ton",
	Nan:"Nan",
	Pei:"Pei",
	Shaa:"Shaa",

	Chun:"Chun",
	Haku:"Haku",
	Hatsu:"Hatsu",

	Seasons1:"BlackBlank",
	Seasons2:"BlackBlank",
	Seasons3:"BlackBlank",
	Seasons4:"BlackBlank",

	Flowers1:"Blank",
	Flowers2:"Blank",
	Flowers3:"Blank",
	Flowers4:"Blank",
}

const TypeCustomBg = {
	Man1:"stockcouple1",
	Man2:"stockcouple1",
	Man3:"stockcouple1",
	Man4:"stockcouple1",
	Man5:"stockcouple1",
	Man6:"stockcouple1",
	Man7:"stockcouple1",
	Man8:"stockcouple1",
	Man9:"stockcouple1",
	
	Pin1:"stockcouple2",
	Pin2:"stockcouple2",
	Pin3:"stockcouple2",
	Pin4:"stockcouple2",
	Pin5:"stockcouple2",
	Pin6:"stockcouple2",
	Pin7:"stockcouple2",
	Pin8:"stockcouple2",
	Pin9:"stockcouple2",

	Sou1:"stockcouple3",
	Sou2:"stockcouple3",
	Sou3:"stockcouple3",
	Sou4:"stockcouple3",
	Sou5:"stockcouple3",
	Sou6:"stockcouple3",
	Sou7:"stockcouple3",
	Sou8:"stockcouple3",
	Sou9:"stockcouple3",

	Ton:"stockcouple4",
	Nan:"stockcouple4",
	Pei:"stockcouple4",
	Shaa:"stockcouple4",

	Chun:"stockcouple5",
	Haku:"stockcouple5",
	Hatsu:"stockcouple5",

	Seasons1:"stockcouple6",
	Seasons2:"stockcouple6",
	Seasons3:"stockcouple6",
	Seasons4:"stockcouple6",

	Flowers1:"stockcouple7",
	Flowers2:"stockcouple7",
	Flowers3:"stockcouple7",
	Flowers4:"stockcouple7",
}

const group_winds = [Ton, Nan, Pei, Shaa]
const group_dragons = [Chun, Haku, Hatsu]
const group_seasons = [Seasons1, Seasons2, Seasons3, Seasons4]
const group_flowers = [Flowers1, Flowers2, Flowers3, Flowers4]

static func types_match(t1, t2):
	if t1 == t2:
		return true
	if t1 in group_winds and t2 in group_winds:
		return true
	if t1 in group_dragons and t2 in group_dragons:
		return true
	if t1 in group_seasons and t2 in group_seasons:
		return true
	if t1 in group_flowers and t2 in group_flowers:
		return true

# Given a type, return a new type from the same group
static func get_types_from_same_group(type:String)->Array:
	var ret = []
	if type in group_winds:
		ret = group_winds.duplicate()
	if type in group_dragons:
		ret = group_dragons.duplicate()
	if type in group_seasons:
		ret = group_seasons.duplicate()
	if type in group_flowers:
		ret = group_flowers.duplicate()
	ret.erase(type)
	return ret

static func type_texture_path(type):
	var textureName = TypeTexture[type]
	return "res://assets/fremd/Regular/"+textureName+".png"

static func type_custombg_path(type):
		var textureName = TypeCustomBg.get(type)
		if textureName:
			return "res://assets/customtiles/"+textureName+".jpg"
		else:
			return null
