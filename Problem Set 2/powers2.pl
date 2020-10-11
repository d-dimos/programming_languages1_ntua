add_zeros(Zeros, []) :-
  Zeros =< 0, !.
add_zeros(Zeros, [0|Tail]) :-
  Zeros_left is Zeros-1,
  add_zeros(Zeros_left, Tail). 

/* Rule: Fixes Mag_log accordingly */
fix_log(N, K, Temp_log, Max_log) :-
  N - 2^Temp_log < K - 1,
  Fix_log is Temp_log - 1,
  fix_log(N, K, Fix_log, Max_log).
fix_log(_, _, Max_log, Max_log) :- !.
/* Last minute helper */
aux([F|Tail], Log, Log, Temp_list) :-
  New is F + 1,
  append([New], Tail, Temp_list). 
aux(Tillnow, _, _, Temp_list) :-
  append([1], Tillnow, Temp_list).

/* Rule: Creates the list of powers */
create_list(0, 0, Before, List, Prev_log) :-
  add_zeros(Prev_log, Z),
  append(Z, Before, List).
create_list(_, 0, _, [], _) :- !.
create_list(N, K, _, [], _) :-
  N < K.
create_list(N, K, Before, List, Prev_log) :-
  N =:= K,
  Prev_log =\= -1,
  Zeros is Prev_log - 1,
  add_zeros(Zeros, Z),
  append( [K|Z], Before, List).
create_list(N, K, Before, List, _) :-
  N =:= K,
  append([K], Before, List).
create_list(N, K, Before, List, Prev_log) :-
  log2N(N, Temp),
  fix_log(N, K, Temp, Max_log),
  Zeros is Prev_log - Max_log - 1,
  add_zeros(Zeros, Z),
  append(Z, Before, With_zeros),
  aux(With_zeros, Max_log, Prev_log, Temp_list),
  New_N is N - 2^Max_log,
  New_K is K - 1,
  create_list(New_N, New_K, Temp_list, List, Max_log).


/* Rule: Does the repeatitive work */
repeat_process(_, [], 0) :- !.
repeat_process(Stream, [Powers|Z], T) :-
  read_line(Stream, [N,K|[]]),
  create_list(N, K, [], Powers, -1),
  W is T-1,
  repeat_process(Stream, Z, W).

/* Main Program */
powers2(Input, Answers) :-
  open(Input, read, Stream),
  read_line(Stream, [T]), 
  repeat_process(Stream, Answers, T), !,
  close(Stream).

/* Rule: Reads a line from input file */
read_line(Stream, List) :-
  read_line_to_codes(Stream, Line),
  atom_codes(Actual, Line),
  atomic_list_concat(Atoms, ' ', Actual),
  maplist(atom_number, Atoms, List).

/* Rule: Calculate logN base 2 */
log2N(1, 0).
log2N(N, Ans) :-
    N > 1,
    N1 is N div 2,
    log2N(N1, A),
    Ans is A + 1.