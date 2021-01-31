extends Control

onready var cbEnableSfx:CheckBox = find_node("EnableSound")
onready var cbEnableMusic:CheckBox = find_node("EnableMusic")
onready var slSoundVolume:Slider = find_node("SoundVolume")
onready var slMusicVolume:Slider = find_node("MusicVolume")


# Called when the node enters the scene tree for the first time.
func _ready():
	cbEnableSfx.pressed = SettingsManager.enable_sfx
	cbEnableMusic.pressed = SettingsManager.enable_music
	slSoundVolume.value = SettingsManager.sfx_volume * 100
	slMusicVolume.value = SettingsManager.music_volume * 100
	pass # Replace with function body.

func save():
	SettingsManager.save_settings()

func _on_EnableSound_toggled(button_pressed):
	SettingsManager.enable_sfx = button_pressed
	pass # Replace with function body.


func _on_EnableMusic_toggled(button_pressed):
	SettingsManager.enable_music = button_pressed
	pass # Replace with function body.


func _on_SoundVolume_value_changed(value):
	SettingsManager.sfx_volume = value/100
	pass # Replace with function body.


func _on_MusicVolume_value_changed(value):
	SettingsManager.music_volume = value/100
	pass # Replace with function body.


func _on_TextureButton_pressed():
	save()
	SceneManager.change_scene("Levels/LayoutList.tscn")
	pass # Replace with function body.
