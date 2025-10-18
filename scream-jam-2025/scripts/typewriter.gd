extends RichTextLabel


#var tween: Tween = create_tween()
#tween.tween_property(self, "visible_ratio", 1.0, 2.0).from(0.0)
#
#variables for typing speed, total characters, and the current character count or time elapsed. 
#
#check if typing is active. If so, add delta time to a timer or directly increment the visible_characters based on text_speed and delta. 

@export var chars_per_second: float = 30.0
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
