extends Node

## SEÑALES
# flujo
signal on_transition_begin(speed)
signal on_transition_end
signal on_enable(scene)
signal on_disable(scene)
signal on_game_end()
# juego
# herramientas
signal equipar_herramienta(index) #que herramienta 
signal desequipar()
# eventos luego hare limpieza no creo que todos estos se usen
signal mostrar_evento(tipo)
signal esconder_evento()
signal mostrar_dialogo()
signal esconder_dialogo()
signal mostrar_imagen()
signal esconder_imagen()

## lógica del juego
# herramientas
var seleccionada = 0
var equipada = -1 
# flujo e inspeccion
var mensaje_actual = 0; # menasej a mostrar
enum Partes { CABEZA, BRAZO1, BRAZO2, PIERNA1, PIERNA2 }
var cuerpo = [ -1, -1, -1, -1, -1 ] # -1 si está sin tocar, 0 si has fallado y 1 si lo has curado
var intentos = 3;
var desbloq_ultima = false # ultima herramienta desbloqueada

## maquina de estados y variables de flujo
var sm # state machine
var current_scene = Scenes.INTRO 
var next_scene = Scenes.INTRO
var coolDown = 0.5
var startCoolDown = false
## MUY IMPORTANTE: MISMO ORDEN QUE EN EL SERIALIZED ARRAY DE LA STATEMACHINE
enum Scenes { INTRO, GAME, NULL}

## sonido
var sfx
var bgm

## input
var cm # cursor manager


func _ready() -> void:
	pass

func  _process(delta: float) -> void:
	if startCoolDown:
		if coolDown <= 0:
			startCoolDown = false
			coolDown = 0.5
		else:
			coolDown-= delta
	pass

func change_scene(next : Global.Scenes, speed = 1.0, force = true):
	Global.next_scene = next
	#print(">> Changing from ", Global.current_scene, " to ", Global.next_scene)
	if ((current_scene != next || force) and not startCoolDown):
		#startCoolDown = true
		Global.on_transition_begin.emit(speed)
