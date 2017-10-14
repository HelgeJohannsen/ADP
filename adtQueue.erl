%%%-------------------------------------------------------------------
%%% @author Helge
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Okt 2017 20:00
%%%-------------------------------------------------------------------
-module(adtQueue).
-author("Helge").

%% API
-export([main/0, createQ/0 ,enqueue/2]).

main() -> Q1 = createQ(),
 Q2 =  enqueue(Q1,32),
 Q3 =  enqueue(Q2,44),
  Q4 =  enqueue(Q3,55),
  dequeue(Q4).

createQ() -> {queue, stack:createS(), stack:createS()}.

enqueue({queue, SIn,Sout}, Elem) -> {queue, stack:push(SIn,Elem),Sout}.

dequeue(Queue = {queue, S1,{stack, {list,empty,endoflist}} }) -> switch(Queue).

dequeue(_) -> ok.

switch(Queue = {queue, {stack, {list,empty,endoflist}},Stack2}) -> Queue;
switch(Queue = {queue, Stack1,Stack2}) -> Elem = stack:top(Stack1),
  Stack22 = stack:push(Stack2,Elem), Stack11 = stack:pop(Stack1),
  switch({queue,Stack11,Stack22}).

