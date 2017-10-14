%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Algorithmen und Datenstrukturen                       %%
%% Praktikumsaufgabe 1 : Die Kunst der Abstraktion       %%
%%                                                       %%
%% bearbeitet von Helge Johannsen und Christian Stüber   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(liste).
-export([main/0, run_tests/0, create/0, isEmpty/1, isList/1, equal/2, laenge/1, insert/3, delete/2, find/2, retrieve/2, concat/2, diffListe/2, eoCount/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rekursive Implementierung des ADT Liste                                    %%
%%                                                                            %%
%% Listenform : {list, HEAD, TAIL}                                            %%
%%                                                                            %%
%% list = list 		, atomares Tag zur Identifizierung der Liste              %%
%%                                                                            %%
%% HEAD = empty 	, bei leerer Liste                                        %%
%%		  WERT  	, bei nicht leerer Liste                                  %%
%%                                                                            %%
%% TAIL = endoflist , Tag zum kennzeichnen des Listenendes                    %%
%%		  WERT 		, naechstes Element der Liste                             %%
%%                                                                            %%
%% Beispiel leere Liste 		: {list, empty, endoflist}                    %%
%% Beispiel nicht leere Liste 	: {list, 1, {list, 2, {list, 5, endoflist}}}  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
main() -> L = {list, 42, endoflist},
          G = {list, 55, endoflist},
  insert(L,1,G),
  L.
%%
%% Erzeugt eine leere Liste.
%%
%% Signatur | create: (/) → list
%%
create() -> {list, empty, endoflist}.

%%
%% Prueft ob die gegebene Liste leer ist.
%%
%% Signatur | isEmpty: list → bool
%%
isEmpty({list, empty, endoflist}) 	-> true;
isEmpty({list, _, _}) 				-> false;
isEmpty(_) 							-> ok. %% ignoriere falsche Eingabe

%%
%% Prueft ob der gegebene Wert eine List ist.
%%
%% Signatur | isList: list → bool
%%
isList({list, _, _}) 	-> true;
isList(_) 				-> false. %% ignoriere falsche Eingaben

%%
%% Prueft ob die Listen identisch sind.
%%
%% Signatur | equal: list x list → bool
%%
equal({list, A, B}, {list, A, B}) 	-> true;
equal({list, _, _}, {list, _, _}) 	-> false;
equal(_, _) 						-> ok. %% ignoriere falsche Eingabe

%%
%% Berechnet die Laenge der Liste.
%%
%% Signatur | laenge: list → int
%%
laenge({list, empty, endoflist}) 	-> 0;
laenge({list, _, endoflist}) 		-> 1;
laenge({list, _, T}) 				-> 1 + laenge(T);
laenge(_) 							-> ok. %% ignoriere falsche Eingabe

%%
%% Fuegt das Element an das Ende der Liste an.
%%
%% Signatur | append: list x elem → list
%%
append({list, empty, endoflist}, Elem) 	-> {list, Elem, endoflist};
append({list, H, endoflist}, Elem) 		-> {list, H, {list, Elem, endoflist}};
append({list, H, T}, Elem) 				-> {list, H, append(T, Elem)};
append(_, _) 							-> ok. %% ignoriere falsche Eingabe

%%
%% Fuegt das Element an der angegeben Position ein.
%%
%% 1 <= Pos <= laenge + 1
%%
%% Signatur | insert: list x pos x elem → list
%%
insert(LIST = {list, _, _}, Pos, Elem) ->
  MaxPos = laenge(LIST) + 1,
  if Pos <  1; Pos  > MaxPos -> LIST; %% bei falscher Pos urspruengliche Liste zurueckgeben
    Pos >= 1, Pos =< MaxPos -> insert_helper(LIST, Pos, Elem)
  end;
insert(_, _, _) -> ok. %% ignoriere falsche Eingaben
%%
%% Wenn CurrentPos > 1 , iteriere weiter
%%      CurrentPos = 1 , fuege das neue Element ein
%%		T = endoflist && CurrentPos = 2 , fuege das neue Element an das Ende ein
%%
insert_helper({list, empty, endoflist}, 1, Elem) -> {list, Elem, endoflist}; 					%% bei leerer Liste
insert_helper({list, H, T}, 			1, Elem) -> {list, Elem, {list, H, T}}; 				%% am Anfang oder in der Mitte einfügen
insert_helper({list, H, endoflist}, 	2, Elem) -> {list, H, {list, Elem, endoflist}}; 		%% am Ende einfügen
insert_helper({list, H, T}, 		  Pos, Elem) -> {list, H, insert_helper(T, Pos - 1, Elem)}. %% iterate

%%
%% Loescht das Element an der angegeben Position.
%%
%% 1 <= Pos <= laenge
%%
%% Signatur | delete: list x pos → list
%%
delete(LIST = {list, _, _}, Pos) ->
  MaxPos = laenge(LIST),
  if Pos <  1; Pos  > MaxPos -> LIST; 						%% bei falscher Pos urspruengliche Liste zurueckgeben
    Pos >= 1, Pos =< MaxPos -> delete_helper(LIST, Pos)
  end;
delete(_, _) -> ok. %% ignoriere falsche Eingaben
%%
%% Wenn Pos > 3 , iteriere weiter
%%      Pos = 2 , loesche das naechste Element
%%		Pos = 1 , loesche sich selbst, geht nur beim ersten Element, unterscheide Liste mit 1 oder mehr Elementen
%%
delete_helper({list, H, {list, _, TT}}, 2) 	-> {list, H, TT}; 							%% in der Mitte oder am Ende
delete_helper({list, _, endoflist}, 1) 		-> {list, empty, endoflist};				%% am Anfang , 1 Element
delete_helper({list, _, T}, 		1) 		-> T;										%% am Anfang , mehr als 1 Element
delete_helper({list, H, T}, 		  Pos) 	-> {list, H, delete_helper(T, Pos - 1)}. 	%% iterate

%%
%% Sucht das Element in der Liste und gibt die Position zurueck.
%%
%% Signatur | find: list x elem → pos
%%
find(LIST = {list, _, _}, Elem) -> find_helper(LIST, 1, Elem);
find(_, _) 						-> ok. %% ignoriere falsche Eingaben
%%
find_helper(endoflist, _, _) 				-> 0;										%% nicht in der Liste
find_helper({list, Elem, _}, Index, Elem) 	-> Index; 									%% gefunden
find_helper({list, _, T}, Index, Elem) 		-> find_helper(T, Index + 1, Elem).			%% nicht gefunden, weiter mit dem Tail

%%
%% Holt das Element von der angegebenen Position.
%%
%% Signatur | retrieve: list x pos → elem
%%
retrieve({list, empty, endoflist}, _) 	-> nil;
retrieve(endoflist, _) 					-> nil;
retrieve({list, H, _}, 1) 				-> H;
retrieve({list, _, T}, Pos) 			-> retrieve(T, Pos - 1);
retrieve(_, _) 							-> ok. %% ignoriere falsche Eingaben

%%
%% Konkateniert zwei Listen.
%%
%% Signatur | concat: list x list → list
%%
concat({list, empty, endoflist}, LIST = {list, _, _}) -> LIST;
concat(LIST = {list, _, _}, {list, empty, endoflist}) -> LIST;
concat({list, H, endoflist}, LISTAPP = {list, _, _})  -> {list, H, LISTAPP};
concat({list, H, T}, LISTAPP = {list, _, _}) 		  -> {list, H, concat(T, LISTAPP)};
concat(_, _) 										  -> ok. %% ignoriere falsche Eingaben

%%
%% Gibt eine Liste zurueck bestehend aus den Element der ersten Liste ohne die Elemente aus der zweiten Liste.
%%
%% Signatur | diffListe: list x list → list
%%
diffListe({list, empty, endoflist}, _) 						-> {list, empty, endoflist};
diffListe(LIST = {list, _, _}, {list, empty, endoflist}) 	-> LIST;
diffListe(LIST1 = {list, _, _}, LIST2 = {list, _, _})		-> diffListe_helper(create(), LIST1, LIST2);
diffListe(_, _)												-> ok.
%%
diffListe_helper(LISTACCU, endoflist, _) 		-> LISTACCU;
diffListe_helper(LISTACCU, {list, H, T}, LIST2) ->
  case find(LIST2, H) of
    0 -> diffListe_helper(append(LISTACCU, H), T, LIST2);
    _ -> diffListe_helper(LISTACCU, T, LIST2)
  end.

%%
%% Zaehlt die Anzahl der in der Laenge geraden bzw. ungeraden Listen in der Liste L inklusive dieser Liste selbst,
%% also alle moeglichen Listen! Eine leere Liste wird als Liste mit gerader Laenge angesehen. In der Liste koennen
%% Elemente vorkommen, die keine Liste sind. Rueckgabe ist das Tupel [<Anzahl gerade>,<Anzahl ungerade>]
%%
%% Signatur | eoCount: list → [int,int]
%%
eoCount({list, empty, endoflist}) 	-> [1, 0];
eoCount(LIST = {list, _, _}) 		-> eoCount_helper([0, 0], LIST);
eoCount(_)							-> ok.
%%
eoCount_helper([G, U], LIST = {list, _, _}) ->
  [G1,U1] = case laenge(LIST) rem 2 of
              1 -> [G,U+1];
              0 -> [G+1,U]
            end,
  [G2,U2] = eoCount_lists(filter(LIST, fun isList/1)),
  [G1+G2,U1+U2].
%%
eoCount_lists({list, empty, endoflist}) -> [0, 0];
eoCount_lists(LIST = {list, _, _}) 		-> eoCount_lists_helper([0, 0], LIST).
%%
eoCount_lists_helper(ACCU, endoflist) 			-> ACCU;
eoCount_lists_helper([G1, U1], {list, H, T}) 	->
  [G2, U2] = eoCount(H),
  eoCount_lists_helper([G1+G2,U1+U2], T).

%%
%% Gibt eine Liste zurueck bestehend aus den Elementen fuer die das Praedikat P wahr ergibt.
%%
%% Signatur | filter: list x func → list
%%
filter({list, empty, endoflist}, _) 		-> {list, empty, endoflist};
filter(LIST = {list, _, _}, P) 				-> filter_helper(create(), LIST, P);
filter(_, _)								-> ok.
filter_helper(ACCU, endoflist, _) 		-> ACCU;
filter_helper(ACCU, {list, H, T}, P) 	->
  case P(H) of
    true  -> filter_helper(append(ACCU, H), T, P);
    false -> filter_helper(ACCU, T, P)
  end.

%%
%% Wendet auf jedes Element der Liste die Mappingfunktion an und gibt die daraus enstehenden Elemente in einer neuen Liste zurueck.
%%
%% Signatur | map: list x func → list
%%
map({list, empty, endoflist}, _) 		-> {list, empty, endoflist};
map(LIST = {list, _, _}, M) 			-> map_helper(create(), LIST, M);
map(_, _)								-> ok.
map_helper(ACCU, endoflist, _) 		-> ACCU;
map_helper(ACCU, {list, H, T}, M) 	-> map_helper(append(ACCU, M(H)), T, M).



%%
%% Wendet eine gegebene Funktion auf jedes Element der Liste an.
%%
%% Signatur | foreach: list x func → atom
%%
foreach({list, empty, endoflist}, _) 	-> ok;
foreach(endoflist, _) 					-> ok;
foreach({list, H, T}, F) 				-> F(H), foreach(T, F);
foreach(_, _) 							-> ok.

%%%%%%%%%%%%%%%%
%% Testfaelle %%
%%%%%%%%%%%%%%%%
test_create() ->
  MyListEmpty = create(),
  RESULT = (MyListEmpty == {list, empty, endoflist}),
  io:format("test_create: ~p~n", [RESULT]).

test_isEmpty() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  RESULT = isEmpty(MyListEmpty)
    and not isEmpty(MyListNotEmpty1)
    and not isEmpty(MyListNotEmpty2),
  io:format("test_isEmpty: ~p~n", [RESULT]).

test_isList() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  NotAList1 = {2},
  NotAList2 = {42, 2},
  NotAList3 = 42,
  RESULT = isList(MyListEmpty)
    and isList(MyListNotEmpty1)
    and isList(MyListNotEmpty2)
    and not isList(NotAList1)
    and not isList(NotAList2)
    and not isList(NotAList3),
  io:format("test_isList: ~p~n", [RESULT]).

test_equal() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  RESULT = equal(MyListEmpty, MyListEmpty)
    and equal(MyListNotEmpty1, MyListNotEmpty1)
    and equal(MyListNotEmpty2, MyListNotEmpty2)
    and not equal(MyListEmpty, MyListNotEmpty1)
    and not equal(MyListNotEmpty1, MyListNotEmpty2),
  io:format("test_equal: ~p~n", [RESULT]).

test_laenge() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  RESULT = 	(laenge(MyListEmpty) 	 == 0)
    and (laenge(MyListNotEmpty1) == 1)
    and (laenge(MyListNotEmpty2) == 2),
  io:format("test_laenge: ~p~n", [RESULT]).

test_append() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  RESULT = 	(append(MyListEmpty, 42) 	 == {list, 42, endoflist})
    and (append(MyListNotEmpty1, 42) == {list, 1, {list, 42, endoflist}})
    and (append(MyListNotEmpty2, 42) == {list, 1, {list, 42, {list, 42, endoflist}}}),
  io:format("test_append: ~p~n", [RESULT]).

test_insert() -> 	%% work in progress
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  RESULT = 	(insert(MyListEmpty, 1, 22) 	== {list, 22, endoflist})
    and (insert(MyListNotEmpty1, 1, 33) == {list, 33, {list, 1, endoflist}})
    and (insert(MyListNotEmpty1, 2, 44) == {list, 1, {list, 44, endoflist}})
    and (insert(MyListNotEmpty2, 1, 33) == {list, 33, {list, 1, {list, 42, endoflist}}})
    and (insert(MyListNotEmpty2, 2, 33) == {list, 1, {list, 33, {list, 42, endoflist}}})
    and (insert(MyListNotEmpty2, 3, 33) == {list, 1, {list, 42, {list, 33, endoflist}}})
    and (insert(MyListEmpty, -1, 33) == MyListEmpty)
    and (insert(MyListEmpty, 2, 33) == MyListEmpty)
    and (insert(MyListNotEmpty1, -1, 33) == MyListNotEmpty1)
    and (insert(MyListNotEmpty1, 3, 33) == MyListNotEmpty1)
    and (insert(MyListNotEmpty2, -1, 33) == MyListNotEmpty2)
    and (insert(MyListNotEmpty2, 4, 33) == MyListNotEmpty2),
  io:format("test_insert: ~p~n", [RESULT]).

test_delete() ->
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 42, endoflist}},
  MyListNotEmpty3 = {list, 1, {list, 66, {list, 42, endoflist}}},
  RESULT = 	(delete(MyListNotEmpty1, 1) == {list, empty, endoflist})
    and (delete(MyListNotEmpty2, 1) == {list, 42, endoflist})
    and (delete(MyListNotEmpty2, 2) == {list, 1, endoflist})
    and (delete(MyListNotEmpty3, 2) == {list, 1, {list, 42, endoflist}})
    and (delete(MyListNotEmpty3, 5) == MyListNotEmpty3)
    and (delete(MyListNotEmpty3, -2) == MyListNotEmpty3)
    and (delete(MyListNotEmpty1, 2)  == MyListNotEmpty1)
    and (delete(MyListNotEmpty1, -1) == MyListNotEmpty1)
    and (delete(MyListNotEmpty1, 0)  == MyListNotEmpty1),
  io:format("test_delete: ~p~n", [RESULT]).

test_find() ->
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 66, {list, 42, endoflist}}},
  RESULT = 	(find(MyListNotEmpty1, 1)  == 1)
    and (find(MyListNotEmpty1, 33) == 0)
    and (find(MyListNotEmpty2, 1)  == 1)
    and (find(MyListNotEmpty2, 66) == 2)
    and (find(MyListNotEmpty2, 42) == 3),
  io:format("test_find: ~p~n", [RESULT]).

test_retrieve() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 66, {list, 42, endoflist}}},
  RESULT = 	(retrieve(MyListEmpty,     1) == nil)
    and (retrieve(MyListNotEmpty1, 1) == 1)
    and (retrieve(MyListNotEmpty1, 2) == nil)
    and (retrieve(MyListNotEmpty2, 1) == 1)
    and (retrieve(MyListNotEmpty2, 2) == 66)
    and (retrieve(MyListNotEmpty2, 3) == 42)
    and (retrieve(MyListNotEmpty2, -2) == nil),
  io:format("test_retrieve: ~p~n", [RESULT]).

test_concat() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 66, {list, 42, endoflist}}},
  RESULT = 	(concat(MyListEmpty, MyListEmpty) == MyListEmpty)
    and (concat(MyListEmpty, MyListNotEmpty1) == MyListNotEmpty1)
    and (concat(MyListEmpty, MyListNotEmpty2) == MyListNotEmpty2)
    and (concat(MyListNotEmpty1, MyListNotEmpty1) == {list, 1, {list, 1, endoflist}})
    and (concat(MyListNotEmpty1, MyListNotEmpty2) == {list, 1, {list, 1, {list, 66, {list, 42, endoflist}}}})
    and (concat(MyListNotEmpty2, MyListNotEmpty2) == {list, 1, {list, 66, {list, 42, {list, 1, {list, 66, {list, 42, endoflist}}}}}}),
  io:format("test_concat: ~p~n", [RESULT]).

test_diffListe() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty1 = {list, 1, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 66, {list, 42, endoflist}}},
  MyListNotEmpty3 = {list, 33, {list, 66, {list, 42, {list, 2, endoflist}}}},
  RESULT = 	(diffListe(MyListEmpty, MyListEmpty) == MyListEmpty)
    and (diffListe(MyListEmpty, MyListNotEmpty1) == MyListEmpty)
    and (diffListe(MyListNotEmpty2, MyListNotEmpty2) == MyListEmpty)
    and (diffListe(MyListNotEmpty1, MyListNotEmpty2) == MyListEmpty)
    and (diffListe(MyListNotEmpty2, MyListNotEmpty1) == {list, 66, {list, 42, endoflist}})
    and (diffListe(MyListNotEmpty3, MyListNotEmpty2) == {list, 33, {list, 2, endoflist}}),
  io:format("test_diffListe: ~p~n", [RESULT]).

test_eoCount() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 66, {list, 42, endoflist}}},
  MyListNotEmpty3 = {list, 33, {list, 66, {list, 42, {list, 2, endoflist}}}},
  MyListNotEmpty4 = insert(insert(MyListNotEmpty3, 1, MyListNotEmpty2), 3, MyListNotEmpty2),
  MyListNotEmpty5 = {list, MyListNotEmpty4, endoflist},
  MyListNotEmpty6 = append(append(MyListEmpty, MyListEmpty), MyListEmpty),
  RESULT = 	(eoCount(MyListEmpty) 		== [1, 0])
    and (eoCount(MyListNotEmpty2) 	== [0, 1])
    and (eoCount(MyListNotEmpty3) 	== [1, 0])
    and (eoCount(MyListNotEmpty4) 	== [1, 2])
    and (eoCount(MyListNotEmpty5) 	== [1, 3])
    and (eoCount(MyListNotEmpty6) 	== [3, 0]),
  io:format("test_eoCount: ~p~n", [RESULT]).

test_filter() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty2 = {list, 1, {list, 66, {list, 42, endoflist}}},
  MyListNotEmpty3 = {list, 33, {list, 66, {list, 42, {list, 2, endoflist}}}},
  MyListNotEmpty4 = insert(insert(MyListNotEmpty3, 1, MyListNotEmpty2), 3, MyListNotEmpty2),
  RESULT = 	(filter(MyListEmpty, fun isList/1) 		== MyListEmpty)
    and (filter(MyListNotEmpty2, fun isList/1) 	== MyListEmpty)
    and (filter(MyListNotEmpty3, fun isList/1) 	== MyListEmpty)
    and (filter(MyListNotEmpty4, fun isList/1) 	== {list, MyListNotEmpty2, {list, MyListNotEmpty2, endoflist}}),
  io:format("test_filter: ~p~n", [RESULT]).

test_map() ->
  MyListEmpty = {list, empty, endoflist},
  MyListNotEmpty2 = {list, 1, endoflist},
  MyListNotEmpty3 = {list, 33, {list, 5, {list, 20, {list, 2, endoflist}}}},
  Mult = fun(Arg) -> 3*Arg end,
  RESULT = 	(map(MyListEmpty, Mult) 	== MyListEmpty)
    and (map(MyListNotEmpty2, Mult) == {list, 3, endoflist})
    and (map(MyListNotEmpty3, Mult) == {list, 99, {list, 15, {list, 60, {list, 6, endoflist}}}}),
  io:format("test_map: ~p~n", [RESULT]).

%%test_reduce() ->
%%  MyListEmpty = {list, empty, endoflist},
%%  MyListNotEmpty2 = {list, 1, endoflist},
%%  MyListNotEmpty3 = {list, 33, {list, 5, {list, 20, {list, 2, endoflist}}}},
%%  Add = fun(Arg1, Arg2) -> Arg1 + Arg2 end,
%%  RESULT = 	(reduce(MyListEmpty, Add) 	== MyListEmpty)
%%    and (reduce(MyListNotEmpty2, Add) == {list, 3, endoflist})
%%    and (reduce(MyListNotEmpty3, Add) == {list, 99, {list, 15, {list, 60, {list, 6, endoflist}}}}),
%%  io:format("test_reduce: ~p~n", [RESULT]).


%%%%%%%%%%%%%%%%%
%%	Entrypoint %%
%%%%%%%%%%%%%%%%%
run_tests() ->
  %% ADT List Testcases
  test_create(),
  test_isEmpty(),
  test_isList(),
  test_equal(),
  test_laenge(),
  test_append(),
  test_insert(),
  test_delete(),
  test_find(),
  test_retrieve(),
  test_concat(),
  test_diffListe(),
  test_eoCount(),
  test_filter(),
  test_map().
%MyList = append(append(append(create(), 42), 21), 1),
%F = fun(Arg) -> io:format("~p~n", [Arg]) end,
%foreach(MyList, F).


