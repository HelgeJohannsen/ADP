%%%-------------------------------------------------------------------
%%% @author Helge
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Okt 2017 04:12
%%%-------------------------------------------------------------------
-module(liste).
-author("Helge").

%% API
-export([main/0,create/0,isEmpty/1,isList/1,equal/2,laenge/1,insert/3, delete/2, find/2,retrieve/2, concat/2, diffList/3]).

main() ->
  List1 = {3,{5,{2,{8}}}},
  List2 = {3,{5,{8,{8}}}},
  List3 = {},
  List4 = {3},
%%  isEmpty(List4).
%%  equal(List1,List2).
%%  insert(List1,1,7).
  insert(List1,5,9).

create() -> List = {}.

isEmpty(List) -> List == {}.

isList(List) -> is_tuple(List).

equal({},{}) -> true;
equal({E1},{E2}) -> true;
equal(List1,List2) ->
  {E1,RestList1} = List1,
  {E2,RestList2} = List2,
  if E1 == E2 -> equal(RestList1,RestList2);
    true -> false
  end.

laenge({}) -> 0;
laenge({A}) -> 1;
laenge(List) -> {_A,B} = List,
  1 + laenge(B).


insert(List, 1, Element) -> {Element, List};
insert(List, Position, Element) ->
  {Head, Tail} = List,
  NewList = {Head, insert(Tail, Position - 1, Element)},
  NewList.

%%delete(L,Pos) -> delete(L,Pos,)
%%delete({A},_) -> {A};
%% Abbruch der Rekursion muss zwei elementiges Tupel sein sonst wird letztes element nicht gelöscht
delete({H,T},1) -> T;
delete({H1,{_}},2) -> {H1};
delete({H,T},Pos) -> {H, delete(T,(Pos-1))}.


find(List,Elem) -> find(List,Elem,1).
find({Elem},Elem, Pos) -> Pos;
find({Elem,T},Elem, Pos) -> Pos;
find({HList,TList},Elem,Pos) -> find(TList,Elem,(Pos+1)).

retrieve({H,T},1) -> H;
retrieve({H},1) -> H;
retrieve({H,T},Pos) -> retrieve(T,(Pos-1)).

concat({H1},L2) -> {H1,L2};
concat({H1,T1},L2) -> {H1,concat(T1,L2)}.

diffList(L1, {}, L1) -> true;
diffList(L1, {Kopf2,Rest2}, L3) -> true.
