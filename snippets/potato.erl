-module(potato).
-compile(export_all).

loop(State) ->
    receive
        {From, set, Newstate} ->
            From ! ok,
            loop(Newstate);
        {From, get} ->
            From ! {ok, State},
            loop(State);
        {From, bye} ->
            From ! ok
    end.

new() ->
    spawn(fun() -> loop(empty) end).

set(Pid, Value) ->
    Pid ! {self(), set, Value}.

get(Pid) ->
    Pid ! {self(), get},
    receive
        {ok, State} -> State
    end.

bye(Pid) ->
    Pid ! {self(), bye},
    receive
        ok -> ok
    end.
