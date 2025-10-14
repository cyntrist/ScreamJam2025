extends Scene

func on_enable():
	$Reintentar.enabled = true;
	pass

func on_disable():
	pass

func _on_reintentar_pressed() -> void:
	if (!Global.input_enabled): return;
	$Reintentar.enabled = false;
	Global.change_scene(Global.Scenes.GAME)
	pass # Replace with function body.
