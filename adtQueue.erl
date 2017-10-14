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
-export([main/0, createQ/0 ,enqueue/2, front/1, isEmptyQ/1, equalQ/2]).

main() -> Q1 = createQ(),
 Q2 =  enqueue(Q1,32),
 Q3 =  enqueue(Q2,44),
  Q4 =  enqueue(Q3,55),
 Q5 = dequeue(Q4),
  enqueue(Q5,5),
  front(Q5),
  equalQ(Q5,Q5).

createQ() -> {queue, stack:createS(), stack:createS()}.

enqueue({queue, SIn,Sout}, Elem) -> {queue, stack:push(SIn,Elem),Sout}.

dequeue(Queue = {queue, _S1,{stack, {list,empty,endoflist}} }) -> dequeue(switch(Queue));
dequeue(Queue = {queue, S1, S2}) -> {queue, S1, stack:pop(S2)};
dequeue(_) -> ok.

switch(Queue = {queue, {stack, {list,empty,endoflist}},Stack2}) -> Queue;
switch(Queue = {queue, Stack1,Stack2}) -> Elem = stack:top(Stack1),
  Stack22 = stack:push(Stack2,Elem), Stack11 = stack:pop(Stack1),
  switch({queue,Stack11,Stack22}).

front({queue, _S1, S2}) -> stack:top(S2).

isEmptyQ({queue, S1, S2}) ->  (stack:isEmptyS(S1) and stack:isEmptyS(S2)).

equalQ({queue, S1, S2},{queue, S3, S4}) -> (stack:equalS(S1,S3) and stack:equalS(S2, S4)).
