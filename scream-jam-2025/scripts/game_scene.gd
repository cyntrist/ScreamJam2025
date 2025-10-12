extends Scene

@export var srp_herram: Array[Texture2D] = [] # sprites de las distintas herramientas
@onready var btn_selec = $Interfaz/Herramientas/Seleccionar # boton de seleccionar
#enum Herramientas { ... } cuando sepamos cuales van a ser
var ind_selec = 0; # indice de la herramienta seleccionada

func on_enable():
	ind_selec = 0
	btn_selec.texture_normal = srp_herram[ind_selec]
	pass

func on_disable():
	pass

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func cambiar_herramienta(sentido):
	pass


func _on_abajo_pressed() -> void:
	print_debug("ABAJO")
	ind_selec -= 1
	if (ind_selec < 0):
		ind_selec = srp_herram.size() - 1;
	btn_selec.texture_normal = srp_herram[ind_selec]
	pass # Replace with function body.


func _on_arriba_pressed() -> void:
	print_debug("ARRIBA")
	ind_selec += 1
	if (ind_selec >= srp_herram.size()):
		ind_selec = 0;
	btn_selec.texture_normal = srp_herram[ind_selec]
	pass # Replace with function body.


func _on_seleccionar_pressed() -> void:
	print_debug("SELECCION")
	pass # Replace with function body.


func _on_equipada_pressed() -> void:
	print_debug("DESEQUIPAR")
	pass # Replace with function body.
