:- use_module(library(pce)).

visual:-new(D,dialog('CATEXPERT - JUEGO SIMULADOR PARA APRENDIZAJE DE SISTEMAS EXPERTOS BASADOS EN REGLAS',size(400,300))),
	new(@boton1,button('1',message(@prolog,espera,1))),
	new(@boton2,button('2',message(@prolog,espera,2))),
	new(@boton3,button('3',message(@prolog,espera,3))),
	new(@boton4,button('4',message(@prolog,espera,4))),
	new(@boton5,button('5',message(@prolog,espera,5))),
	new(@boton6,button('6',message(@prolog,espera,6))),
	new(@boton7,button('7',message(@prolog,espera,7))),
	new(@boton8,button('8',message(@prolog,espera,8))),
	new(@boton9,button('9',message(@prolog,espera,9))),
	new(@btnhumano,button('Inicia Humano',message(@prolog,inicio_humano))),
	new(@btnmaquina,button('Inicia Computadora',message(@prolog,inicio_maquina))),
	new(@btncerrar,button('Cerrar',message(@prolog,liberar,D))),
	send(D,append,@boton1),
	send(D,append,@boton2),
	send(D,append,@boton3),
	send(D,append,@boton4),
	send(D,append,@boton5),
	send(D,append,@boton6),
	send(D,append,@boton7),
	send(D,append,@boton8),
	send(D,append,@boton9),
	send(D,append,@btnmaquina),
	send(D,append,@btnhumano),
	send(D,append,@btncerrar),
	send(D,open).


liberar(D):- free(@boton1),
	free(@boton2),
	free(@boton3),
	free(@boton4),
	free(@boton5),
	free(@boton6),
	free(@boton7),
	free(@boton8),
	free(@boton9),
	free(@btnhumano),
	free(@btnmaquina),
	free(@btncerrar),
	send(D,destroy),
	fin.

:- dynamic x/1.
:- dynamic o/1.

ocupado(Lugar):- x(Lugar).
ocupado(Lugar):- o(Lugar).
libre(Lugar):- not(ocupado(Lugar)).

trio_ganador(1,5,9).
trio_ganador(1,4,7).
trio_ganador(3,5,7).
trio_ganador(4,5,6).
trio_ganador(1,2,3).
trio_ganador(7,8,9).
trio_ganador(2,5,8).
trio_ganador(3,6,9).

gato:- trio_ganador(CasillaA,CasillaB,CasillaC),x(CasillaA),x(CasillaB),x(CasillaC).
gato:- trio_ganador(CasillaA,CasillaB,CasillaC),o(CasillaA),o(CasillaB),o(CasillaC).

tablero_lleno:- ocupado(1),ocupado(2),ocupado(3),ocupado(4),ocupado(5),ocupado(6),ocupado(7),ocupado(8),ocupado(9).
empate:- tablero_lleno, not(gato).

desventaja_en(CasillaB):- trio_ganador(CasillaA,CasillaB,CasillaC),o(CasillaA),libre(CasillaB),o(CasillaC).
desventaja_en(CasillaC):- trio_ganador(CasillaA,CasillaB,CasillaC),o(CasillaA),o(CasillaB),libre(CasillaC).
desventaja_en(CasillaA):- trio_ganador(CasillaA,CasillaB,CasillaC),libre(CasillaA),o(CasillaB),o(CasillaC).

ventaja_en(CasillaC):- trio_ganador(CasillaA,CasillaB,CasillaC),x(CasillaA),x(CasillaB),libre(CasillaC).
ventaja_en(CasillaB):- trio_ganador(CasillaA,CasillaB,CasillaC),x(CasillaA),x(CasillaC),libre(CasillaB).
ventaja_en(CasillaA):- trio_ganador(CasillaA,CasillaB,CasillaC),x(CasillaB),x(CasillaC),libre(CasillaA).


necesario_defender(L):- trio_ganador(A,L,C),o(A),libre(C),libre(L).
necesario_defender(L):- trio_ganador(A,B,L),o(A),libre(B),libre(L).
necesario_defender(L):- trio_ganador(L,B,C),o(B),libre(C),libre(L).

necesario_atacar(L):- trio_ganador(A,L,B),x(A),libre(B),libre(L).
necesario_atacar(L):- trio_ganador(A,B,L),x(A),libre(B),libre(L).
necesario_atacar(L):- trio_ganador(L,A,B),x(A),libre(B),libre(L).

movimiento_pc:-write('La computadora dice: Pensando mi movimiento'),nl, lugar_elegido(L),assert(x(L)),write(L),imp_tablero,jugar_humano.

lugar_valido(L):- L>0, L<10, libre(L).

lugar_elegido(L):- ventaja_en(L),write('Elegí atacar aquí porque tengo la ventaja').
lugar_elegido(L):- desventaja_en(L),write('Elegí defender aquí porque tengo la desventaja').
lugar_elegido(L):- necesario_defender(L),write('Elegí esta posición para defender porque quizá quieras construir un trio ganador').
lugar_elegido(L):- necesario_atacar(L),write('Elegí esta posición para atacar para poder construir un trio ganador').
lugar_elegido(L):- (random(1,10,L),libre(L));lugar_elegido(L).


limpiar:- retractall(x(_)),retractall(o(_)).

espera(L):-(lugar_valido(L),assert(o(L)),imp_tablero,jugar_pc);writeln('Posición Inválida, Intenta de nuevo').

movimiento_humano:- (nl,writeln('Genera tu movimiento -Casilleros [1-9]-')).

imp_l(L):- x(L), write('x').
imp_l(L):- o(L), write('o').
imp_l(L):- libre(L), write('-').

separador:- write('______________________________').
espaciado:-write(''),nl.

imp_tablero:- espaciado, separador,nl,tab(5),imp_l(1),tab(5),imp_l(2),tab(5),imp_l(3),nl,nl,tab(5),imp_l(4),tab(5),imp_l(5),tab(5),imp_l(6),nl,nl,tab(5),imp_l(7),tab(5),imp_l(8),tab(5),imp_l(9),nl,separador.

fin:- gato,write('Se logró un GATO ¡Hay un ganador!'),nl.
fin:- empate,write('Hubo un Empate, Eso significa que no has podido ganarme.'),nl.

inicio_humano:- limpiar,jugar_humano.
inicio_maquina:- limpiar,jugar_pc.

jugar_humano:- fin.
jugar_humano:- movimiento_humano.
jugar_pc:- fin.
jugar_pc:- movimiento_pc.
