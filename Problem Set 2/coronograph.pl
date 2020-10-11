% inputs one line
get_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  atom_codes(Actual, Line),
  atomic_list_concat(Atoms, ' ', Actual),
  maplist(atom_number, Atoms, List).

% creates graph
create(_, 0, _):- !.
create(Stream, M, Neigh):-
  get_line(Stream, [V1,V2|[]]),
  arg(V1, Neigh, V1_list),
  arg(V2, Neigh, V2_list),
  ( nonvar(V1_list),
    append([V2], V1_list, New1),
    nb_setarg(V1, Neigh, New1);
    V1_list = [V2] ),
  ( nonvar(V2_list),
    append([V1], V2_list, New2),
    nb_setarg(V2, Neigh, New2);
    V2_list = [V1] ),
  W is M - 1,
  create(Stream, W, Neigh).

% searches for cycle
cycleDFS(Neigh, Node, Visited, Parents, A1, A2):-
  nb_setarg(Node, Visited, 1),
  arg(Node, Neigh, List),
  nth0(_, List, Nb),
  arg(Nb, Visited, Marked),
  arg(Node, Parents, Father),
  ( nonvar(Marked),
    Nb =\= Father,
    A1 = Node,
    A2 = Nb;
    var(Marked),
    nb_setarg(Nb, Parents, Node),
    cycleDFS(Neigh, Nb, Visited, Parents, A1, A2)
  ).

% stores cycle
get_cycle(End, End, [], L, L, _, _):- !.
get_cycle(Start, End, [Node|Rest], Temp, L, Incircle, Parents):-
  Node = Start,
  arg(Node, Incircle, 1),
  arg(Node, Parents, Next),
  W is Temp + 1,
  get_cycle(Next, End, Rest, W, L, Incircle, Parents).

% ------------------- Sums Calculator ----------------------------
count(Node, Neigh, Visited, Parents, Incircle, Partial):-
  arg(1, Partial, Value),
  Temp is Value + 1,
  nb_setarg(1, Partial, Temp),
  nb_setarg(Node, Visited, 1),
  arg(Node, Neigh, List),
  nth0(_, List, Nb),
  arg(Node, Parents, Father),
  arg(Nb, Incircle, Isin), var(Isin),
  arg(Nb, Visited, Marked),

  ( nonvar(Marked),
    Nb =\= Father,
    nb_setarg(1, Partial, 0),
    fail;
    var(Marked),
    nb_setarg(Nb, Parents, Node),
    count(Nb, Neigh, Visited, Parents, Incircle, Partial) ).
    
sums_aux(_, _, _, _, _, [], []).
sums_aux(Neigh, Visited, Parents, Partial, Incircle, [Root|Rest], [Sub_sum|Rest_sums]):-
  nb_setarg(Root, Parents, -1),
  nb_setarg(1, Partial, 0),
  (count(Root, Neigh, Visited, Parents, Incircle, Partial) ; true),
  arg(1, Partial, Sub_sum),
  \+ Sub_sum = 0,
  sums_aux(Neigh, Visited, Parents, Partial, Incircle, Rest, Rest_sums).

make_sums(N, Neigh, Cycle, Incircle, Sums) :-
  functor(Visited, array, N),
  functor(Parents, array, N),
  functor(Partial, array, 1),
  sums_aux(Neigh, Visited, Parents, Partial, Incircle, Cycle, Unsorted_sums),
  msort(Unsorted_sums, Sums).
% ------------------------------------------------------------

% checks connectivity
connected([], 0).
connected([], _):- fail.
connected([S|Rest], N):-
  W is N-S,
  connected(Rest, W).

% repeats algorithm T times
repeat(_, 0, []).
repeat(Stream, T, [Ans|Rest]):-
  get_line(Stream, [N,M|[]]),
  functor(Neigh, array, N),
  functor(Incircle, array, N),
  functor(Visited, array, N),
  functor(Parents, array, N),
  create(Stream, M, Neigh),
  setarg(1, Parents, -1),
  ( N =:= M,
    cycleDFS(Neigh, 1, Visited, Parents, A1, A2),
    Found is 1;
    Found is 0  ),
  ( Found =:= 1,
    arg(A2, Parents, Father2),
    get_cycle(A1, Father2, Cycle, 0, L, Incircle, Parents),
    make_sums(N, Neigh, Cycle, Incircle, Sums),
    connected(Sums, N),
    Ans = [L, Sums];
    Ans = '\'NO CORONA\'' ), !,
  W is T - 1,
  repeat(Stream, W, Rest).

% party starter
coronograph(Input, Answers) :-
  open(Input, read, Stream),
  get_line(Stream, [T]),
  repeat(Stream, T, Answers), !,
  close(Stream).