extends TextureButton

class_name Boton

@export var hover_color : Color = Color(0.623, 0.136, 0.14, 1.0)
@export var clicked_color : Color = Color(0.247, 0.247, 0.247, 1.0)
var dentro = false;

func _ready() -> void:
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	self.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	pass
	

func _on_mouse_entered() -> void:
	self.modulate = hover_color
	dentro = true;
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	dentro = false;
	pass # Replace with function body.

func _input(event):
	if dentro:
		if Input.is_action_just_pressed("Click"):
			self.modulate = clicked_color
		elif Input.is_action_just_released("Click"):
			if dentro:
				self.modulate = hover_color;
			else:
				self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	pass 
