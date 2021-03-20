% program start
vaccine(Input, Answers):-
    open(Input, read, Stream),
    get_T(Stream, [T]),
    repeat(Stream, T, Answers), !,
    close(Stream).


% reads a line from input stream
get_T(Stream, List):-
    read_line_to_codes(Stream, Line),
    atom_codes(Actual, Line),
    atomic_list_concat(Atoms, ' ', Actual),
    maplist(atom_number, Atoms, List).


% repeats algorithm T times
repeat(_, 0, []).
repeat(Stream, T, [Vaccine|Rest]):-
    read_string(Stream, "\n", "\r", _, Seq),
    string_chars(Seq, Inv_RNA),
    reverse(Inv_RNA, RNA),    % transform into processable form
    covid_19(RNA, Vaccine),
    W is T - 1,
    repeat(Stream, W, Rest).


% returns the vaccine
covid_19([First|Rest], Vaccine):-
    Rest = [] -> Vaccine = p;
    stage_one(First, Rest, Vaccine). % Exist = {A, G, C, U}


% prepare the queue
stage_one(First, [Base|Rest], Vaccine):-
    Rest = [] -> Vaccine = pp;
    complement(Base,Comp),

    %  possibility1: p
    (Base = First -> Exist1 = [First]; Exist1 = [Base,First]),
    State1 = ["pp",  [Base,First], 0, Exist1, Rest],
    %  possibility2: cp
    (Comp = First -> Exist2 = [First]; Exist2 = [Comp,First]),
    State2 = ["pcp", [Comp,First], 1, Exist2, Rest],

    % start the game
    init_queue(Empty_Q1),
    init_queue(Empty_Q2),

    en_queue(Empty_Q1, State1, Temp),
    en_queue(Temp, State2, States_queue),

    synthesis(States_queue, Vaccine, Empty_Q2).


% synthesis(States_queue, Vaccine, Candidate_vaccines).       State = [Vaccine_so_far, [Top,Bottom], C_flag, Existence, Remaining_RNA]
synthesis(States_queue, Vaccine, Candidates):-
    States_queue = Sth-_, var(Sth), Candidates = List-[], best_medicine(List, Vaccine).
synthesis(States_queue_, Vaccine, Candidates):-
    de_queue(States_queue_, State, States_queue),
    State = [So_far, [Top,Bottom], C_flag, Set, [Given|Rest]],
    (C_flag = 0 -> Base = Given; complement(Given, Base)),
    complement(Base, Comp),

    (Rest \= [] ->
    (
        (%  possibility 1:  Base does NOT exist OR it is same as Top
            ((\+ member(Base,Set), append([Base], Set, Set1)); (Base = Top, Set1 = Set)) ->
                    atom_concat(So_far, "p", Poss_1), 
                    Next_1 = [Poss_1, [Base,Bottom], C_flag, Set1, Rest],
                    en_queue(States_queue, Next_1, Exp1); Exp1 = States_queue
        ),
        (%  possibility 2:  Complementary base does NOT exist OR it is same as Top
            ((\+ member(Comp,Set), append([Comp], Set, Set2)); (Comp = Top, Set2 = Set)) ->
                    atom_concat(So_far, "cp", Poss_2), New_flag is xor(C_flag, 1),
                    Next_2 = [Poss_2, [Comp,Bottom], New_flag, Set2, Rest],
                    en_queue(Exp1, Next_2, Exp2); Exp2 = Exp1
        ),
        (%  possibility 3:  Base does NOT exist OR it is same as Bottom
            ((\+ member(Base,Set), append([Base], Set, Set3)); (Base = Bottom, Set3 = Set)) -> 
                    atom_concat(So_far, "rp", Poss_3), 
                    Next_3 = [Poss_3, [Base,Top], C_flag, Set3, Rest],
                    en_queue(Exp2, Next_3, Exp3); Exp3 = Exp2
        ),
        (%  possibility 4:  Complementary base does NOT exist OR it is same as Bottom
            ((\+ member(Comp,Set), append([Comp], Set, Set4)); (Comp = Bottom, Set4 = Set)) ->
                    atom_concat(So_far, "crp", Poss_4), New_flag is xor(C_flag, 1),
                    Next_4 = [Poss_4, [Comp,Top], New_flag, Set4, Rest],
                    en_queue(Exp3, Next_4, Exp4); Exp4 = Exp3
        ),
        synthesis(Exp4, Vaccine, Candidates)
    );
    (
        (%  possibility 1:  Base does NOT exist OR it is same as Top
            ( (\+ member(Base,Set)); Base = Top) ->
                    atom_concat(So_far, "p", Poss_1), en_queue(Candidates, Poss_1, Ok1); Ok1 = Candidates 
        ),
        (%  possibility 2:  Complementary base does NOT exist OR it is same as Top
            ( (\+ member(Comp,Set)); Comp = Top) ->
                    atom_concat(So_far, "cp", Poss_2), en_queue(Ok1, Poss_2, Ok2); Ok2 = Ok1
        ),
        (%  possibility 3:  Base does NOT exist OR it is same as Bottom
            ( (\+ member(Base,Set)); Base = Bottom) -> 
                    atom_concat(So_far, "rp", Poss_3), en_queue(Ok2, Poss_3, Ok3); Ok3 = Ok2
        ),
        (%  possibility 4:  Complementary base does NOT exist OR it is same as Bottom
            ( (\+ member(Comp,Set)); Comp = Bottom) ->
                    atom_concat(So_far, "crp", Poss_4), en_queue(Ok3, Poss_4, Ok4); Ok4 = Ok3
        ),
        synthesis(States_queue, Vaccine, Ok4)
    )).


% returns shortest and lexicographically smallest solution
best_medicine(Candidate_vaccines, Vaccine):-
    sort(Candidate_vaccines, Lex_sorted),
    sort_atoms_by_length(Lex_sorted, ByLength),
    ByLength = [Vaccine|_].


% sort strings by length (for this prob they need to be lexsorted first)
sort_atoms_by_length(Atoms, ByLength) :-
    map_list_to_pairs(atom_length, Atoms, Pairs),
    keysort(Pairs, Sorted),
    pairs_values(Sorted, ByLength).


% complementary bases
complement('A', 'U').
complement('U', 'A').
complement('C', 'G').
complement('G', 'C').


% QUEUE IMPLEMENTATION
% initialization
init_queue(U-U).

% enqueue
en_queue(Q, Elem, New_Q) :-     
    append_dl(Q, [Elem|U]-U, New_Q).

% dequeue
de_queue([H|T]-U, H, T-U).

% O(1) append
append_dl(A-B, B-C, A-C).
