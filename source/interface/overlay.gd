extends Control

func _process(delta):
	if Data.player_data.has("position"):
		$debug/pos.text = str(Data.player_data["position"].x) + " " + str(Data.player_data["position"].y) + " " + str(Data.player_data["position"].z)

func _set_auth(id):
	set_multiplayer_authority(id)
