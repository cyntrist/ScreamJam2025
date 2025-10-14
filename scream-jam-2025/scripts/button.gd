extends TextureButton

class_name Boton

@export var hover_color : Color = Color(0.623, 0.136, 0.14, 1.0)
@export var clicked_color : Color = Color(0.247, 0.247, 0.247, 1.0)
@export var off_color : Color = Color(1.0, 1.0, 1.0, 1.0)
var dentro = false;
var enabled = true;

func _ready() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	self.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	pass
	

func _on_mouse_entered() -> void:
	if !enabled or !Global.input_enabled: return
	self.modulate = hover_color
	dentro = true;
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	if !enabled or !Global.input_enabled: return
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	dentro = false;
	pass # Replace with function body.

func _input(_event):
	# TODO: QUE CUANDO ESTA GLOBAL INPUT A FALSE SE VEAN DESACTIVADES!!!!
	if !enabled: 
		self.modulate = off_color
		return
	if dentro:
		if Input.is_action_just_pressed("Click"):
			self.modulate = clicked_color
		elif Input.is_action_just_released("Click"):
			if dentro:
				self.modulate = hover_color;
			else:
				self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	pass 
