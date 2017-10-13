%%%-------------------------------------------------------------------
%%% @author Helge
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Okt 2017 15:23
%%%-------------------------------------------------------------------
-module(stack).
-author("Helge").

%% API
-export([createS/0, push/2, pop/1]).

createS() -> {stack, liste:create()}.

push({stack, L}, Elem) -> {stack, liste:insert(L, 1, Elem)}.

pop({stack, L}) -> {stack, liste:delete(L,1)}.
