extends Node

# Load the custom images for the mouse cursor.
var mano = load("res://assets/herramientas/cursores/cursor.png")
var mano_clic = load("res://assets/herramientas/cursores/cursor_clic.png")
@export var spr_herram: Array[Texture2D] = [] # sprites de los cursores de las herramientas
var desequipada = true;

func _ready():
	# Changes only the arrow shape of the cursor.
	# This is similar to changing it in the project settings.
	Input.set_custom_mouse_cursor(mano)

	Global.cm = self
	Global.equipar_herramienta.connect(_equipar_herramienta)
	Global.desequipar.connect(_desequipar_herramienta)
	# Changes a specific shape of the cursor (here, the I-beam shape).
	#Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)

func _equipar_herramienta(index):
	desequipada = false;
	Global.equipada = index;
	Input.set_custom_mouse_cursor(spr_herram[index])
	pass

func _desequipar_herramienta():
	desequipada = true;
	Global.equipada = -1;
	Input.set_custom_mouse_cursor(mano)
	pass
	
func _input(event):
	if desequipada:
		if Input.is_action_just_pressed("Click"):
			Input.set_custom_mouse_cursor(mano_clic)
		elif Input.is_action_just_released("Click"):
			Input.set_custom_mouse_cursor(mano)
	## si los cursores de las herramientas van a estar animados......
	pass 
