(* ------------------ Mapping System ------------------ *)
fun pair_compare ((a1, b1),(a2, b2)) = 
  if a1 < a2 then LESS else if a1 > a2 then GREATER else
  if b1 < b2 then LESS else if b1 > b2 then GREATER else EQUAL

structure Key = struct
  type ord_key = int * int
  val compare = pair_compare
end
structure Map = BinaryMapFn(Key)

(* ----------------- Input Processing ----------------- *)
(* Removes #"\n" from list*)
fun fix_list (l : char list) = 
  List.take(l, (List.length l - 1))

(* Returns a list of lists (rows of input lines) *)
fun get_lists (stream : TextIO.instream) =
  case TextIO.inputLine stream
  of SOME string => fix_list(String.explode string)::get_lists stream
  |  NONE        => []

(* -------------------- The Party --------------------- *)    
fun stayhome (input : string) =
  let
    fun first_arg  (a,b,c) = a
    fun second_arg (a,b,c) = b
    fun third_arg  (a,b,c) = c

    val stream = TextIO.openIn input
    val lists  = get_lists stream
    val grid   = Array2.fromList(lists)
    val rows   = Array2.nRows(grid)
    val cols   = Array2.nCols(grid)

    fun get_x (a,b) =
      if (a > ~1 andalso b > ~1) then Array2.sub(grid, a, b)
      else #"Q"

    val S = ref (0,0)
    val T = ref (0,0)
    val W = ref (0,0)
    val A = ref []

    fun search (S, T, W, A, row, col) =
      let
        val x = get_x (row, col)
      in
        if row = ~1 then () else
        if col = ~1 then search (S, T, W, A, row-1, cols-1)
        else
          if x = #"S" then (S := (row, col); search (S, T, W, A, row, col-1)) else
          if x = #"T" then (T := (row, col); search (S, T, W, A, row, col-1)) else
          if x = #"W" then (W := (row, col); search (S, T, W, A, row, col-1)) else
          if x = #"A" then (A := (row, col)::(!A); search (S, T, W, A, row, col-1))
          else search (S, T, W, A, row, col-1)
      end
    
    val seconds  = ref (Map.empty)
    fun set_sec ((a, b), sec)  = Map.insert(!seconds, (a,b), sec) 
    fun get_sec (a, b)         = Map.find(!seconds, (a,b))

    val queue      = Queue.mkQueue()
    val done       = ref false 
    val got_to_air = ref false 
    val wait       = ref 0     
    val pandemia   = ref false

    fun infect_airports [] _          = ()
    |   infect_airports (x::xs) timer = (
          if get_sec(x) = NONE then (
            seconds := set_sec(x, timer);
            Queue.enqueue(queue, x) )
          else ();
          infect_airports xs timer )

    fun spread_infection () =
      let
        val (a,b)      = Queue.head(queue)
        val SOME timer = get_sec(a,b)
      in (
        if not(!pandemia) then (
          if not(!got_to_air) andalso get_x(a,b) = #"A" then (
            got_to_air := true;
            wait := timer + 4 )
          else if (!got_to_air) andalso timer = !wait then (
            infect_airports (!A) (timer+1);
            pandemia := true )
          else () )
        else ();
        Queue.dequeue(queue);
        if a+1 < rows andalso get_sec(a+1,b) = NONE andalso get_x(a+1,b) <> #"X" then (
          seconds := set_sec((a+1, b), timer+2); Queue.enqueue(queue, (a+1,b))   )
        else ();
        if a-1 >= 0   andalso get_sec(a-1,b) = NONE andalso get_x(a-1,b) <> #"X" then (
          seconds := set_sec((a-1, b), timer+2); Queue.enqueue(queue, (a-1,b))   )
        else ();
        if b+1 < cols andalso get_sec(a,b+1) = NONE andalso get_x(a,b+1) <> #"X" then (
          seconds := set_sec((a, b+1), timer+2); Queue.enqueue(queue, (a,b+1))   )
        else ();
        if b-1 >= 0   andalso get_sec(a,b-1) = NONE andalso get_x(a,b-1) <> #"X" then (
          seconds := set_sec((a, b-1), timer+2); Queue.enqueue(queue, (a,b-1))   )
        else ();
        if Queue.isEmpty(queue) then ()
        else spread_infection ()
        )
      end

    val queue2     = Queue.mkQueue()
    val father     = Array2.array(rows, cols, ((~1,~1), #"O", ~1))
    val solvable   = ref false
    val steps      = ref ~1

    fun dad_move_steps ((a,b),dad,move,steps) = Array2.update(father,a,b,(dad,move,steps))

    fun solution () =
      let
        val (x,y) = Queue.head(queue2)
        
        fun dad_steps () = third_arg(Array2.sub(father,x,y))
        fun marked (a,b) = first_arg(Array2.sub(father,a,b)) <> (~1,~1)
        fun is_safe(a,b) = case get_sec (a,b)
          of SOME int => if int > dad_steps()+1 then true else false
          |  NONE     => true 
      in (
        if get_x(x,y) = #"T" then (solvable := true; steps := dad_steps() )
        else();
        if not(!solvable) then (
          Queue.dequeue(queue2);
          if x+1 < rows andalso get_x(x+1,y) <> #"X" andalso not(marked(x+1,y)) andalso is_safe(x+1,y) then (
            dad_move_steps((x+1,y),(x,y),#"D",dad_steps()+1); Queue.enqueue(queue2, (x+1,y)) )
          else ();
          if y-1 >= 0   andalso get_x(x,y-1) <> #"X" andalso not(marked(x,y-1)) andalso is_safe(x,y-1) then (
            dad_move_steps((x,y-1),(x,y),#"L",dad_steps()+1); Queue.enqueue(queue2, (x,y-1)) )
          else ();
          if y+1 < cols andalso get_x(x,y+1) <> #"X" andalso not(marked(x,y+1)) andalso is_safe(x,y+1) then (
            dad_move_steps((x,y+1),(x,y),#"R",dad_steps()+1); Queue.enqueue(queue2, (x,y+1)) )
          else();
          if x-1 >= 0   andalso get_x(x-1,y) <> #"X" andalso not(marked(x-1,y)) andalso is_safe(x-1,y) then (
            dad_move_steps((x-1,y),(x,y),#"U",dad_steps()+1); Queue.enqueue(queue2, (x-1,y)) )
          else();
          
          if not(Queue.isEmpty(queue2)) then solution()
          else ()
        )
        else ()
      )
      end

    fun moves_list (x,y) =
      if        second_arg(Array2.sub(father,x,y)) = #"S" then []
      else ( if second_arg(Array2.sub(father,x,y)) = #"U" then #"U"::moves_list(x+1,y)
        else if second_arg(Array2.sub(father,x,y)) = #"R" then #"R"::moves_list(x,y-1)
        else if second_arg(Array2.sub(father,x,y)) = #"L" then #"L"::moves_list(x,y+1)
        else                                                   #"D"::moves_list(x-1,y)
      )                                                   
  in (
    search (S, T, W, A, rows-1, cols-1);
    Queue.enqueue(queue, !W);
    seconds := set_sec(!W, 0);
    spread_infection ();
    if not(!pandemia) andalso (!got_to_air) then (
      infect_airports (!A) (!wait + 1);
      pandemia := true;
      spread_infection () )
    else ();
    Queue.enqueue(queue2, !S);
    dad_move_steps (!S,(~1,~2),#"S",0);
    solution();
    if !solvable then (
      print(Int.toString(!steps) ^ "\n");
      print(String.implode(List.rev(moves_list(!T))) ^ "\n"))
    else
      print("IMPOSSIBLE\n")
    before TextIO.closeIn stream  )
  end
(* -------------------- GAME OVER --------------------- *)