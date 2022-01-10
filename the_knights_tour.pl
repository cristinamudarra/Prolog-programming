size(8).

solve(InitialState,Trace) :- 
        search(InitialState,[InitialState],Trace).

search(_State,Trace,Trace):-
        is_solution(Trace).

search(State,AccTrace,Trace):-
        try_action(State,NewState),
        validate_state(NewState),       
        no_loop(NewState,AccTrace),
        search(NewState,[NewState|AccTrace],Trace).

no_loop(State,Trace) :-
        not(member(State,Trace)).
        % Using negation here is only `safe'
        % when NewState and AccTrace are already
        % instantiated when no_loop/2 is called.

member(H,[H|_]).
member(H,[_|T]) :-
	member(H,T).

is_solution(Trace) :-
	size(Size),
	SizeSquare is Size*Size,
	length(Trace,SizeSquare),
	no_loops(Trace).
	
no_loops([]).
no_loops([H|T]) :- 
	no_loop(H,T),
	no_loops(T).

try_action((X,Y),(NewX,NewY)) :-
	sign(SignX), NewX is X+SignX*2,
	sign(SignY), NewY is Y+SignY*1.
try_action((X,Y),(NewX,NewY)) :-
	sign(SignX), NewX is X+SignX*1,
	sign(SignY), NewY is Y+SignY*2.

sign(-1).
sign(1).

validate_state((X,Y)) :-
	size(Size),
        X>=1, 
	X=<Size, 
	Y>=1, 
	Y=<Size.
You can use this program by asking the following query: ?- solve((1,1),Sol)..
Note that the search space for this problem is huuuge. As expected this naive generate-and-test strategy turns out to be too slow to in practice as you will see when running the program on your computer. On my computer it still wasn't finished after 12 hours, so I terminated it ;-).
Below is a much more efficient version.
solve(InitialState,Trace) :- 
        search(InitialState,[InitialState],Trace).

search(_State,Trace,Trace):-
        is_solution(Trace).

search(State,AccTrace,Trace):-
        try_action_heuristic(State,AccTrace,NewState), % <---- only difference
        validate_state(NewState),
        no_loop(NewState,AccTrace),
        search(NewState,[NewState|AccTrace],Trace).
