extends Scene

@export var spr_herram: Array[Texture2D] = [] # sprites de las distintas herramientas
@export var spr_imagenes: Array[Texture2D] = [] # sprites de las partes investigadas
@export var feedback_nodos: Array[Control] = [] # nodos de los marcos de selección de cada parte
@onready var btn_selec = $Herramientas/Seleccionar # boton de seleccionar
@onready var btn_deselec = $Herramientas/Deseleccionar # boton de deseleccionar
@onready var nodo_evento = $Evento
var mano = load("res://assets/herramientas/selector/desequipar.png")
var ind_selec = 0; # indice de la herramienta seleccionada
#enum Herramientas { ... } cuando sepamos cuales van a ser

func on_enable():
	ind_selec = 0
	btn_selec.texture_normal = spr_herram[ind_selec]
	pass

func on_disable():
	pass

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass



### HERRAMIENTAS!!!!!!!!!!!!!!!!
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




### BOTONES!!!!!!!!!!!!!!!!
func _on_cabeza_pressed() -> void:
	_investigar(Global.Partes.CABEZA)
	pass # Replace with function body.
	
func _on_torso_pressed() -> void:
	_investigar(Global.Partes.TORSO)
	pass # Replace with function body.
	
func _on_brazo_1_pressed() -> void:
	_investigar(Global.Partes.BRAZO1)
	pass # Replace with function body.
func _on_brazo_2_pressed() -> void:
	_investigar(Global.Partes.BRAZO2)
	pass # Replace with function body.


func _on_pierna_1_pressed() -> void:
	_investigar(Global.Partes.PIERNA1)
	pass # Replace with function body.
func _on_pierna_2_pressed() -> void:
	_investigar(Global.Partes.PIERNA2)
	pass # Replace with function body.

func _investigar(parte):
	if (!Global.input_enabled):
		pass
	if (!feedback_nodos[parte].visible): # SI LA PARTE NO ESTA SELECIONADA ES QUE NO SE VE SU FEEDBACK XD
		_feedback(parte) #ver feedback de la parte
		_mostrar_imagen(parte) # mostrar y actualizar imange
	else: # si ya esta seleccionada se deselecciona
		_deseleccionar(parte)
	pass # Replace with function body.

func _feedback(parte):
	#esconder el resto de partes
	for nodo in feedback_nodos:
		nodo.visible = false;
	#mostrar la nuestra
	feedback_nodos[parte].visible = true;
	pass
	
func _mostrar_imagen(parte):
	nodo_evento.visible = true;
	nodo_evento.get_child(0).texture = spr_imagenes[parte];
	pass
	
func _deseleccionar(parte):
	feedback_nodos[parte].visible = false;
	nodo_evento.visible = false;
