extends Control

func _process(delta):
	if Data.player_data.has("position"):
		$debug/pos.text = str(Data.player_data["position"].x)
