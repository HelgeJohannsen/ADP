%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Algorithmen und Datenstrukturen                       %%
%% Praktikumsaufgabe 1 : Die Kunst der Abstraktion       %%
%%                                                       %%
%% bearbeitet von Helge Johannsen und Christian Stüber   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(stack).
-export([main/0, run_tests/0, createS/0, push/2, pop/1, top/1, isEmptyS/1, equalS/2, reverseS/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Implementierung des ADT Stack mit Realisierung durch ADT Liste             %%
%%                                                                            %%
%% Stackform : {stack, LISTE}                                                 %%
%%                                                                            %%
%% stack = atomares Tag zur Identifizierung des Stacks                        %%
%%                                                                            %%
%% LISTE = interne Liste der Implementierung                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main() -> S = createS(),
  MyStackNotEmpty = createS(),
  MyStackNotEmpty = push(MyStackNotEmpty, 42),
  MyStackNotEmpty = push(MyStackNotEmpty, 55),
  MyStackNotEmpty = push(MyStackNotEmpty, 88),
  top(MyStackNotEmpty).

%%
%% Erzeugt einen leeren Stack.
%%
%% Signatur | createS: (/) → stack
%%
createS() -> {stack, liste:create()}.

%%
%% Push't das Element auf den Stack.
%%
%% Signatur | push: stack x elem → stack
%%
push({stack, L}, Elem) 	-> {stack, liste:insert(L, 1, Elem)};
push(_, _) 				-> ok.

%%
%% Pop't das oberste Element von dem Stack.
%%
%% Signatur | pop: stack → stack
%%
pop(Stack = {stack, L}) ->
  case liste:isEmpty(L) of
    false -> {stack, liste:delete(L, 1)};
    true  -> Stack
  end;
pop(_) -> ok.

%%
%% Gibt das oberste Element von dem Stack zurueck.
%%
%% Signatur | top: stack → elem
%%
top({stack, L}) ->
  case liste:isEmpty(L) of
    false -> liste:retrieve(L, 1);
    true  -> nil
  end;
top(_) -> ok.

%%
%% Testet ob der Stack leer ist.
%%
%% Signatur | isEmptyS: stack → bool
%%
isEmptyS({stack, L}) 	-> liste:isEmpty(L);
isEmptyS(_) 			-> ok.

%%
%% Testet die strukturelle Gleichheit von 2 Stacks.
%%
%% Signatur | equalS: stack x stack → bool
%%
equalS({stack, L1}, {stack, L2}) 	-> liste:equal(L1, L2);
equalS(_, _) 						-> ok.

%%
%% Invertiert den gegebenen Stack.
%%
%% Signatur | reverseS: stack → stack
%%
reverseS(S = {stack, _}) -> reverseS_helper(createS(), S);
reverseS(_) -> ok.
%%
reverseS_helper(ACCU, S) ->
  case isEmptyS(S) of
    true  -> ACCU;
    false -> reverseS_helper(push(ACCU, top(S)), pop(S))
  end.


%%%%%%%%%%%%%%%%
%% Testfaelle %%
%%%%%%%%%%%%%%%%
test_createS() ->
  {stack, L} = createS(),
  RESULT = liste:isList(L)
    and liste:isEmpty(L),
  io:format("test_createS: ~p~n", [RESULT]).

test_push_pop() ->
  MyStackEmpty = createS(),
  MyStackNotEmpty1 = push(MyStackEmpty, 42),
  {stack, L1} = MyStackNotEmpty1,
  MyStackNotEmpty2 = push(MyStackNotEmpty1, 65),
  {stack, L2} = MyStackNotEmpty2,
  MyStackNotEmpty3 = pop(MyStackNotEmpty2),
  {stack, L3} = MyStackNotEmpty3,
  MyStackNotEmpty4 = pop(MyStackNotEmpty3),
  {stack, L4} = MyStackNotEmpty4,
  MyStackNotEmpty5 = pop(MyStackNotEmpty4),
  {stack, L5} = MyStackNotEmpty5,
  RESULT = (liste:laenge(L1) == 1)
    and (liste:find(L1, 65) == 0) %% 0 heisst nicht in der Liste
    and (liste:find(L1, 42) == 1)
    and (liste:laenge(L2) == 2)
    and (liste:find(L2, 65) == 1)
    and (liste:find(L2, 42) == 2)
    and (liste:laenge(L3) == 1)
    and (liste:find(L3, 65) == 0)
    and (liste:find(L3, 42) == 1)
    and (liste:laenge(L4) == 0)
    and (liste:find(L4, 65) == 0)
    and (liste:find(L4, 42) == 0)
    and (liste:laenge(L5) == 0),
  io:format("test_push_pop: ~p~n", [RESULT]).

test_top() -> io:format("test_top: <<TO-DO>>~n").
test_isEmptyS() -> io:format("test_isEmptyS: <<TO-DO>>~n").
test_equalS() -> io:format("test_equalS: <<TO-DO>>~n").

test_reverseS() ->
  MyStackEmpty = createS(),
  MyStackNotEmpty1 = push(MyStackEmpty, 42),
  MyStackNotEmpty2 = push(MyStackNotEmpty1, 65),
  {stack, L2} = MyStackNotEmpty2,
  {stack, L3} = reverseS(MyStackNotEmpty2),
  RESULT = (MyStackEmpty == reverseS(MyStackEmpty))
    and (MyStackNotEmpty2 == reverseS(reverseS(MyStackNotEmpty2)))
    and (liste:laenge(L2) == 2)
    and (liste:find(L2, 65) == 1)
    and (liste:find(L2, 42) == 2)
    and (liste:laenge(L3) == 2)
    and (liste:find(L3, 65) == 2)
    and (liste:find(L3, 42) == 1),
  io:format("test_reverseS: ~p~n", [RESULT]).

%%%%%%%%%%%%%%%%%
%%	Entrypoint %%
%%%%%%%%%%%%%%%%%
run_tests() ->
  %% ADT Stack Testcases
  test_createS(),
  test_push_pop(),
  test_top(),
  test_isEmptyS(),
  test_equalS(),
  test_reverseS().
