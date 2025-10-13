extends Scene

@export var spr_herram: Array[Texture2D] = [] # sprites de las distintas herramientas
@export var feedback_nodos: Array[Texture2D] = [] # nodos de los marcos de selección de cada parte
@onready var btn_selec = $Herramientas/Seleccionar # boton de seleccionar
@onready var btn_deselec = $Herramientas/Deseleccionar # boton de deseleccionar
var mano = load("res://assets/herramientas/selector/desequipar.png")
#enum Herramientas { ... } cuando sepamos cuales van a ser
var ind_selec = 0; # indice de la herramienta seleccionada

func on_enable():
	ind_selec = 0
	#Global.seleccionada = ind_selec;
	btn_selec.texture_normal = spr_herram[ind_selec]
	pass

func on_disable():
	pass

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass


func _on_abajo_pressed() -> void:
	ind_selec -= 1
	var maxI = spr_herram.size() - 1
	if (!Global.desbloq_ultima): # si no esta la ultima herramienta desbloqueada
		maxI -= 1;
	if (ind_selec < 0):
		ind_selec = maxI;
	btn_selec.texture_normal = spr_herram[ind_selec]
	pass # Replace with function body.


func _on_arriba_pressed() -> void:
	ind_selec += 1
	var maxI = spr_herram.size()
	if (!Global.desbloq_ultima): # si no esta la ultima herramienta desbloqueada
		maxI -= 1;
	if (ind_selec >= maxI):
		ind_selec = 0;
	btn_selec.texture_normal = spr_herram[ind_selec]
	pass # Replace with function body.


func _on_seleccionar_pressed() -> void:
	Global.equipar_herramienta.emit(ind_selec);
	btn_deselec.texture_normal = spr_herram[ind_selec]
	pass # Replace with function body.


func _on_equipada_pressed() -> void:
	Global.desequipar.emit();
	btn_deselec.texture_normal = mano
	pass # Replace with function body.
