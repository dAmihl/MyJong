class_name TileType

const Man1 = "Man1"
const Man2 = "Man2"
const Man3 = "Man3"
const Man4 = "Man4"
const Man5 = "Man5"
const Man6 = "Man6"
const Man7 = "Man7"
const Man8 = "Man8"
const Man9 = "Man9"

const Pin1 = "Pin1"
const Pin2 = "Pin2"
const Pin3 = "Pin3"
const Pin4 = "Pin4"
const Pin5 = "Pin5"
const Pin6 = "Pin6"
const Pin7 = "Pin7"
const Pin8 = "Pin8"
const Pin9 = "Pin9"

const Sou1 = "Sou1"
const Sou2 = "Sou2"
const Sou3 = "Sou3"
const Sou4 = "Sou4"
const Sou5 = "Sou5"
const Sou6 = "Sou6"
const Sou7 = "Sou7"
const Sou8 = "Sou8"
const Sou9 = "Sou9"

const Ton = "Ton"
const Nan = "Nan"
const Pei = "Pei"
const Shaa = "Shaa"

const Chun = "Chun"
const Haku = "Haku"
const Hatsu = "Hatsu"

# Seasons (all 4 match)
const Blank = "Blank"
# Flowers (all 4 match)
const Flowers = "BlackBlank"

const TypeNumber = {
	# Suits Dots
	"Man1":4,
	"Man2":4,
	"Man3":4,
	"Man4":4,
	"Man5":4,
	"Man6":4,
	"Man7":4,
	"Man8":4,
	"Man9":4,
	# Suits Bamboo
	"Pin1":4,
	"Pin2":4,
	"Pin3":4,
	"Pin4":4,
	"Pin5":4,
	"Pin6":4,
	"Pin7":4,
	"Pin8":4,
	"Pin9":4,
	# Suits Characters
	"Sou1":4,
	"Sou2":4,
	"Sou3":4,
	"Sou4":4,
	"Sou5":4,
	"Sou6":4,
	"Sou7":4,
	"Sou8":4,
	"Sou9":4,
	# Honors Winds
	"Ton":4,
	"Nan":4,
	"Pei":4,
	"Shaa":4,
	# Honors Dragons
	"Chun":4,
	"Haku":4,
	"Hatsu":4,
	
	# Bonus Seasons and Flowers
	"Seasons":4,
	"Flowers":4
}

const group_winds = [Ton, Nan, Pei, Shaa]
const group_dragons = [Chun, Haku, Hatsu]

static func types_match(t1, t2):
	if t1 == t2:
		return true
	if t1 in group_winds and t2 in group_winds:
		return true
	if t1 in group_dragons and t2 in group_dragons:
		return true

static func type_texture_path(type):
	return "res://assets/fremd/Regular/"+type+".png"
