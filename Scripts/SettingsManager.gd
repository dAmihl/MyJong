extends Node

const settings_file = "user://settings.save"

var enable_music: bool = true setget set_enable_music
var enable_sfx: bool = true setget set_enable_sfx
var music_volume:float = 1.0 setget set_music_volume
var sfx_volume:float = 1.0 setget set_sfx_volume

func _ready():
	load_settings()

func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_sfx)
	f.store_var(enable_music)
	f.store_var(sfx_volume)
	f.store_var(music_volume)
	f.close()

func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		enable_sfx = f.get_var()
		enable_music = f.get_var()
		sfx_volume = f.get_var()
		music_volume = f.get_var()
		f.close()
	set_global_audio_busses()
	
func set_global_audio_busses():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !enable_music)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !enable_sfx)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
		
func set_enable_music(new_val:bool):
	enable_music = new_val
	set_global_audio_busses()
	
func set_enable_sfx(new_val:bool):
	enable_sfx = new_val
	set_global_audio_busses()

func set_music_volume(new_val:float):
	music_volume = new_val
	set_global_audio_busses()
	
func set_sfx_volume(new_val:float):
	sfx_volume = new_val
	set_global_audio_busses()
