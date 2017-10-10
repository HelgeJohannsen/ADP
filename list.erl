%%%-------------------------------------------------------------------
%%% @author Helge
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Okt 2017 04:12
%%%-------------------------------------------------------------------
-module(list).
-author("Helge").

%% API
-export([main/0,create/0,isEmpty/1,isList/1,equal/2,laenge/1,insert/3, delete/2, concat/2,get_head/2]).

main() ->
  List1 = {3,{5,{2,{8}}}},
  List2 = {3,{5,{8,{8}}}},
  List3 = {},
  List4 = {3},
%%  isEmpty(List4).
%%  equal(List1,List2).
%%  insert(List1,1,7).
insert(List1,3,9).

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

insert(A,0,Elem) -> A;
insert({HList,TList},0,Elem) -> {HList};
insert({HList,TList},Pos,Elem)  -> {HList, insert(TList,Pos -1, Elem )}.

%%insert(List,Pos,Elem) -> insert(List,Pos,Elem,{}).
%%insert({},Pos,Elem,List) -> List;
%%insert({A},Pos,Elem,List) -> {A,List};
%%insert(OldList,Pos,Elem,NewList) -> {ActE,RestList} = OldList,
%%  NewList2 = {ActE,NewList},
%%  insert(RestList,Pos,Elem,NewList2).

get_head({Head, _}, 0) -> {Head};
get_head({Head, Tail}, Position) ->
  {Head, get_head(Tail, Position - 1)}.

%%insert(NewList,Pos,Elem,OldList) -> {ActE,RestList} = OldList,
%%  if Pos == (length(NewList) + 1) ->
%%    Newlist2 = {NewList,Elem},
%%    insert(Newlist2,Pos,Elem,RestList);
%%    true ->
%%      Newlist2 = {NewList,ActE},
%%      insert(Newlist2,Pos,Elem,RestList)
%%  end.

%%  actPos = 1 + insert(RestList,Pos,Elem),
%%  actPos == Pos,
%%  List.


delete(List,Pos) ->
  lists:seq(1,laenge(List)).
  


concat(List1,List2) -> List1 + List2.
