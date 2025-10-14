extends Scene

@export var spr_herram: Array[Texture2D] = [] # sprites de las distintas herramientas
@export var feedback_nodos: Array[Control] = [] # nodos de los marcos de selección de cada parte
@onready var btn_selec = $Herramientas/Seleccionar # boton de seleccionar
@onready var btn_deselec = $Herramientas/Deseleccionar # boton de deseleccionar
@onready var nodo_evento = $Evento
var mano = load("res://assets/herramientas/selector/desequipar.png")
var ind_selec = 0; # indice de la herramienta seleccionada
#enum Herramientas { ... } cuando sepamos cuales van a ser
#sprites de las imagenes a mostrar en base a si estan sin tocar, curadas o jodidas
@export var spr_evento_base: Array[Texture2D] = [] # sprites de las partes investigadas sin tocar
@export var spr_evento_curado: Array[Texture2D] = [] # sprites de las partes investigadas curadas
@export var spr_evento_jodido: Array[Texture2D] = [] # sprites de las partes investigadas jodidas

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
	if (!Global.desbloq_ultima): return
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
	else:
		Global.cuerpo[Global.parte_seleccionada] = 0
		Global.intentos -= 1;
		if (Global.intentos <= 0):
			Global.change_scene(Global.Scenes.GAME_OVER)
	_actualizar_img(Global.parte_seleccionada)


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
