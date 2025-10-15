extends Scene

@export var spr_herram: Array[Texture2D] = [] # sprites de las distintas herramientas
#sprites de las imagenes a mostrar en base a si estan sin tocar, curadas o jodidas
@export var spr_evento_base: Array[Texture2D] = [] # sprites de las partes investigadas sin tocar
@export var spr_evento_curado: Array[Texture2D] = [] # sprites de las partes investigadas curadas
@export var spr_evento_jodido: Array[Texture2D] = [] # sprites de las partes investigadas jodidas
@export var spr_consecuencia_curada: Array[Texture2D] = [] 
@export var spr_consecuencia_jodida: Array[Texture2D] = [] 
@export var feedback_nodos: Array[Control] = [] # nodos de los marcos de selección de cada parte

@onready var btn_selec = $Herramientas/Seleccionar # boton de seleccionar
@onready var btn_deselec = $Herramientas/Deseleccionar # boton de deseleccionar
@onready var nodo_evento = $Evento
@onready var cuerpo = $Cuerpo/Base
@onready var manta = $Cuerpo/Manta
@onready var consecuencias = $Cuerpo/Consecuencias

var mano = load("res://assets/herramientas/selector/desequipar.png")
var cuerpo_desvelado = load("res://assets/cuerpo_single.png")
var ind_selec = 0; # indice de la herramienta seleccionada
#enum Herramientas { ... } cuando sepamos cuales van a ser

func on_enable():
	ind_selec = 0
	btn_selec.texture_normal = spr_herram[ind_selec]
	
	# para que el retry vaya bien
	Global.herram_equipada = -1;
	Global.herram_seleccionada = 0;
	Global.intentos = 3;
	Global.parte_seleccionada = -1 # parte que se está investigando ahora mismo, de 0 a 5 y si es -1 no es ninguna
	Global.desbloq_ultima = false # ultima herramienta desbloqueada
	Global.input_enabled = true
	Global.cuerpo = [ -1, -1, -1, -1, -1, -1 ] # -1 si está sin tocar, 0 si has fallado y 1 si lo has curado
	for nodo in feedback_nodos:
		nodo.visible = false;
	nodo_evento.visible = false;
	pass

func on_disable():
	Global.desequipar.emit();
	btn_deselec.texture_normal = mano
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
	else:  # AL FINAL NO PUEDES FALLAR!!
		ind_selec = 4;
		btn_selec.texture_normal = spr_herram[ind_selec]
		return;
	if (ind_selec < 0):
		ind_selec = maxI;
	btn_selec.texture_normal = spr_herram[ind_selec]
	pass # Replace with function body.


func _on_arriba_pressed() -> void:
	ind_selec += 1
	var maxI = spr_herram.size()
	if (!Global.desbloq_ultima): # si no esta la ultima herramienta desbloqueada
		maxI -= 1;
	else: # AL FINAL NO PUEDES FALLAR!!
		_herramienta_final()
		return;
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

func _herramienta_final():
	ind_selec = 4;
	btn_selec.texture_normal = spr_herram[ind_selec]
	btn_deselec.texture_normal = mano
	Global.equipar_herramienta.emit(ind_selec)
	Global.desequipar.emit()
	$Herramientas/Arriba.visible = false
	$Herramientas/Abajo.visible = false
	



### BOTONES!!!!!!!!!!!!!!!!
func _on_cabeza_pressed() -> void:
	_investigar(Global.Partes.CABEZA)
	pass # Replace with function body.
	
func _on_torso_pressed() -> void:
	if (!Global.desbloq_ultima): return
	_investigar(Global.Partes.TORSO)
	pass # Replace with function body.
	
func _on_brazo_2_pressed() -> void:
	_investigar(Global.Partes.MANO)
	pass # Replace with function body.


func _on_pierna_1_pressed() -> void:
	_investigar(Global.Partes.MUSLO)
	pass # Replace with function body.
func _on_pierna_2_pressed() -> void:
	_investigar(Global.Partes.PIE)
	pass # Replace with function body.

func _investigar(parte):
	if (!Global.input_enabled):
		return
	if (!feedback_nodos[parte].visible): # SI LA PARTE NO ESTA SELECIONADA ES QUE NO SE VE SU FEEDBACK XD
		Global.parte_seleccionada = parte;
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
	#nodo_evento.get_child(0).texture = spr_evento_base[parte];
	_actualizar_img(parte)
	pass
	
func _deseleccionar(parte):
	Global.parte_seleccionada = -1;
	feedback_nodos[parte].visible = false;
	nodo_evento.visible = false;



### PRESIONADO EVENTO!!!!!!! 
func _on_imagen_pressed() -> void:
	if (Global.cuerpo[Global.parte_seleccionada] == -1): # si no hay nada seleccionado no hay nada que hacer
		if (Global.herram_equipada != -1): # si estas intentando hacer algo
			_actuar();
		#else: # si ya se ha hecho algo muestra el qué por consola
			#print_debug("Estás usando la mano y la parte está a -1")
	else:
		print_debug("La parte está a: ", Global.cuerpo[Global.parte_seleccionada])

func _actuar() -> void: # hacer algo en la parte del cuerpo
	if (Global.herram_equipada == Global.solucion[Global.parte_seleccionada]):
		Global.cuerpo[Global.parte_seleccionada] = 1 
		consecuencias.get_child(Global.parte_seleccionada).texture = spr_consecuencia_curada[Global.parte_seleccionada]
	else:
		Global.cuerpo[Global.parte_seleccionada] = 0
		consecuencias.get_child(Global.parte_seleccionada).texture = spr_consecuencia_jodida[Global.parte_seleccionada]
		Global.intentos -= 1;
	Global.partes_actuadas += 1;
	_actualizar_img(Global.parte_seleccionada)
	_acabar_o_no(); 


func _actualizar_img(parte):
	match Global.cuerpo[parte]:
		-1:
			nodo_evento.get_child(0).texture_normal = spr_evento_base[parte];
			pass
		0:
			nodo_evento.get_child(0).texture_normal = spr_evento_jodido[parte];
			pass
		1:
			nodo_evento.get_child(0).texture_normal = spr_evento_curado[parte];
			pass
	pass



# gestion
func _acabar_o_no():
	if (Global.partes_actuadas >= 4 and Global.intentos >= 0 and !Global.desbloq_ultima):
		Global.desbloq_ultima = true;
		_herramienta_final() #para que se actualice la herramienta
		_desvelar_cuerpo()
	pass;
		
func _desvelar_cuerpo():
	#cuerpo.texture = cuerpo_desvelado;
	manta.visible = false;
	_deseleccionar(Global.parte_seleccionada)
	
