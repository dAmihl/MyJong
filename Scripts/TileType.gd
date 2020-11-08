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
const Sou8 = "Sou8"
const Sou9 = "Sou9"
const Ton = "Ton"
const Nan = "Nan"
const Pei = "Pei"
const Shaa = "Shaa"
const Chun = "Chun"
const Haku = "Haku"
const Hatsu = "Hatsu"

const TypeNumber = {
	"Man1":6,
	"Man2":6,
	"Man3":6,
	"Man4":6,
	"Man5":6,
	"Man6":6,
	"Man7":6,
	"Man8":6,
	"Man9":6,
	"Pin1":4,
	"Pin2":4,
	"Pin3":4,
	"Pin4":4,
	"Pin5":4,
	"Pin6":4,
	"Pin7":4,
	"Pin8":4,
	"Pin9":4,
	"Sou1":4,
	"Sou2":4,
	"Sou3":4,
	"Sou4":4,
	"Sou5":4,
	"Sou6":4,
	"Sou8":4,
	"Sou9":4,
	"Ton":4,
	"Nan":4,
	"Pei":4,
	"Shaa":4,
	"Chun":2,
	"Haku":2,
	"Hatsu":2
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
