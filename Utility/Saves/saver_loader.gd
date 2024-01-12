extends Node

func save_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	
	var json = JSON.stringify(Save.SAVE_DICT)
	
	file.store_string(json)
	file.close()

func load_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if file == null:
		var new_file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
		var json = JSON.stringify(Save.SAVE_DICT)
		new_file.store_string(json)
		new_file.close()
		return
	else:
		var json = file.get_as_text()
		
		var saved_data = JSON.parse_string(json)
		
		var save_dict_keys = Array(saved_data.keys())
		
		for i in save_dict_keys:
			Save.SAVE_DICT[i] = saved_data[i]
	
	file.close()
