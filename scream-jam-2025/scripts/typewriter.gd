extends RichTextLabel


#var tween: Tween = create_tween()
#tween.tween_property(self, "visible_ratio", 1.0, 2.0).from(0.0)
#
#variables for typing speed, total characters, and the current character count or time elapsed. 
#
#check if typing is active. If so, add delta time to a timer or directly increment the visible_characters based on text_speed and delta. 
@export var chars_per_second: float = 30.0
@export var hover_color : Color = Color(0.0, 0.173, 0.737, 1.0)
@export var normal_color : Color = Color(1.0, 1.0, 1.0, 1.0)
@export var hover_speed = 0.1
var text_displayed: float = 0
var text_length = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	self.text = ""

func _process(delta: float) -> void:
	if text_displayed < 1:
		if text_length > 0:
			text_displayed += (chars_per_second / text_length) * delta
			self.visible_ratio = min(text_displayed, 1.0)

func iniciar_dialogo(ind):
	self.text = tr(str(ind));
	text_length = self.text.length();
	text_displayed = 0;
	self.visible_ratio = 0;


func _on_mouse_entered() -> void:
	#self.add_theme_color_override("default_color", Color(0.0, 0.173, 0.737, 1.0)) 
	
	create_tween().tween_method(
		func(color): add_theme_color_override("default_color", color),
		get_theme_color("default_color"),
		hover_color,
		hover_speed
	)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	#self.add_theme_color_override("default_color", Color(1.0, 1.0, 1.0, 1.0)) 
	create_tween().tween_method(
		func(color): add_theme_color_override("default_color", color),
		get_theme_color("default_color"),
		normal_color,
		hover_speed
	)
	pass # Replace with function body.
