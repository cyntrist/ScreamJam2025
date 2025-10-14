extends Scene

func on_enable():
	$Reintentar.enabled = true;
	$Reintentar.modulate = Color(1.0, 1.0, 1.0, 1.0);
	pass

func on_disable():
	pass

func _on_reintentar_pressed() -> void:
	if (!Global.input_enabled): return;
	$Reintentar.enabled = false;
	$Reintentar.modulate = Color(0.247, 0.247, 0.247, 1.0);
	Global.change_scene(Global.Scenes.GAME)
	pass # Replace with function body.
