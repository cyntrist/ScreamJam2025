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
@onready var dialogo = $"Diálogo"
@onready var persona = $"Diálogo/Persona"
@onready var burbuja = $"Diálogo/Burbuja"
@onready var texto = $"Diálogo/Burbuja/Texto"
@onready var animator = $AnimationPlayer

var mano = load("res://assets/herramientas/selector/desequipar.png")
var medico_mano_baja = load("res://assets/eventos/persona0.png")
var medico_mano_alta = load("res://assets/eventos/persona1.png")
var ind_selec = 0; # indice de la herramienta seleccionada
var es_hora_de_acabar = false;
var final_bueno = false;
#enum Herramientas { ... } cuando sepamos cuales van a ser

func on_enable():
	ind_selec = 0
	btn_selec.texture_normal = spr_herram[ind_selec]
	
	# para que el retry vaya bien
	Global.herram_equipada = -1;
	Global.herram_seleccionada = 0;
	Global.intentos = 3;
	Global.partes_actuadas = 0;
	Global.parte_seleccionada = -1 # parte que se está investigando ahora mismo, de 0 a 5 y si es -1 no es ninguna
	Global.desbloq_ultima = false # ultima herramienta desbloqueada
	#Global.input_enabled = true
	Global.cuerpo = [ -1, -1, -1, -1, -1, -1 ] # -1 si está sin tocar, 0 si has fallado y 1 si lo has curado
	for nodo in feedback_nodos:
		nodo.visible = false;
	nodo_evento.visible = false;
	for child in consecuencias.get_children():
		child.texture = null
	es_hora_de_acabar = false;
	final_bueno = false;
		
	# dialogos?
	Global.input_enabled = false;
	Global.mostrar_dialogo.connect(_mostrar_dialogo)
	pass

func on_disable():
	Global.desequipar.emit();
	btn_deselec.texture_normal = mano
	pass

func _ready() -> void:
	Global.input_enabled = false;	
	pass
	
func _process(_delta: float) -> void:
	pass



### HERRAMIENTAS!!!!!!!!!!!!!!!!
func _on_abajo_pressed() -> void:
	if !Global.input_enabled: return
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
	if !Global.input_enabled: return
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
	if !Global.input_enabled: 
		return
	Global.equipar_herramienta.emit(ind_selec);
	btn_deselec.texture_normal = spr_herram[ind_selec]
	pass # Replace with function body.


func _on_equipada_pressed() -> void:
	if !Global.input_enabled: 
		return
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
	if !Global.input_enabled: return
	_investigar(Global.Partes.CABEZA)
	pass # Replace with function body.
	
func _on_torso_pressed() -> void:
	if !Global.input_enabled: return
	if (!Global.desbloq_ultima): return
	_investigar(Global.Partes.TORSO)
	pass # Replace with function body.
	
func _on_brazo_2_pressed() -> void:
	if !Global.input_enabled: return
	_investigar(Global.Partes.MANO)
	pass # Replace with function body.


func _on_pierna_1_pressed() -> void:
	if !Global.input_enabled: return
	_investigar(Global.Partes.MUSLO)
	pass # Replace with function body.
func _on_pierna_2_pressed() -> void:
	if !Global.input_enabled: return
	_investigar(Global.Partes.PIE)
	pass # Replace with function body.

func _investigar(parte):
	if (!Global.input_enabled):
		return
	#for nodo in feedback_nodos:
		#print_debug(nodo.visible)
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
	#nodo_evento.visible = true;
	_actualizar_img(parte)
	Global.make_visible(nodo_evento, 1.0)
	_esconder_dialogo()
	persona.disabled = true;
	pass
	
func _deseleccionar(parte):
	Global.parte_seleccionada = -1;
	feedback_nodos[parte].visible = false;
	#nodo_evento.visible = false;
	Global.make_visible(nodo_evento, 0.0)
	persona.disabled = false
	Global.make_visible(dialogo, 1.0)



### PRESIONADO EVENTO!!!!!!! 
func _on_imagen_pressed() -> void:
	if !Global.input_enabled: return
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
	if (Global.herram_equipada == 4):
		es_hora_de_acabar = true


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
	if (Global.partes_actuadas >= 4):
		if (Global.intentos > 0):
			if (!Global.desbloq_ultima):
				final_bueno = true
				Global.desbloq_ultima = true;
				_herramienta_final() #para que se actualice la herramienta
				_desvelar_cuerpo()
		else: # TODO: conversación game over
			es_hora_de_acabar = true
			#Global.change_scene(Global.Scenes.GAME_OVER)
	pass;

func _desvelar_cuerpo():
	#cuerpo.texture = cuerpo_desvelado;
	Global.make_visible(manta, 0.0, 3.0)
	await Global.timer(3.0)
	_deseleccionar(Global.parte_seleccionada)
	#_mostrar_persona()

func _on_feedback_pressed() -> void:
	if !Global.input_enabled: return
	_deseleccionar(Global.parte_seleccionada)
	_mostrar_persona()
	pass # Replace with function body.





# DIALOGOS
func _mostrar_dialogo():
	Global.make_visible(dialogo, 1., 0.1)
	Global.make_visible(burbuja, 1., 0.1)
	dialogo.visible = true
	burbuja.visible = true
	#texto.text = tr(str(ind))
	texto.iniciar_dialogo(1)
	persona.texture_normal = medico_mano_alta
	animator.play("medico_tween", -1, 1.0);
	pass

func _mostrar_persona():
	var delay = 0.1;
	Global.make_visible(dialogo, 1., 0.25, delay)
	Global.make_visible(burbuja, 0., 0.25, delay)
	Global.make_visible(persona, 1., 0.25, delay)
	pass

func _esconder_dialogo():
	Global.make_visible(dialogo, 0.5, 0.25)

func _on_burbuja_pressed() -> void:
	if (es_hora_de_acabar):
		var state = Global.Scenes.GAME_OVER
		if (final_bueno):
			state = Global.Scenes.CREDITS
		Global.change_scene(state)
	else:
		Global.input_enabled = true
		Global.habilitar_input.emit()
	#burbuja.visible = false
	Global.make_visible(burbuja, 0., 0.25)
	persona.texture_normal = medico_mano_baja
	pass # Replace with function body.


func _on_persona_pressed() -> void:
	if (Global.input_enabled):
		#await Global.timer(0.25)
		_mostrar_dialogo()
	Global.input_enabled = false
	Global.deshabilitar_input.emit()
	persona.texture_normal = medico_mano_alta
	pass # Replace with function body.
