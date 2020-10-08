fun print_list list =
  let
    val sorted  = ListMergeSort.sort (fn(x,y)=> x>y) list
    fun print_help [] = ()
      | print_help [a] = print (Int.toString(a))
      | print_help list = 
        (
          print (Int.toString(hd list));
          print " ";
          print_help (tl list)
        )
  in
      print_help sorted;
      print "\n"
  end

fun get filename =
  case TextIO.scanStream(Int.scan StringCvt.DEC) filename
  of SOME int => int
  |  NONE     => 0

fun emptier filename 0 = ()
  | emptier filename x = (
      get filename;
      emptier filename (x-1)
    )


fun coronograph (input_file: string) =
  let
    val filename = TextIO.openIn input_file
    val T = get filename
    fun repeater 0 filename = ()
    |   repeater T filename = 
          let
            val N = get filename
            val M = get filename
            val G = Array.array(N+1, [])
            fun addEdge graph v1 v2 = 
              let
                val eleme1 = Array.sub(graph, v1)
                val new1   = v2 :: eleme1
                val eleme2 = Array.sub(graph, v2)
                val new2   = v1 :: eleme2
              in
                Array.update(graph, v1, new1);
                Array.update(graph, v2, new2)
              end
            fun create 0 graph = ()
            |   create M graph =
                  let
                    val v1 = get filename
                    val v2 = get filename
                  in
                    addEdge G v1 v2;
                    create (M-1) G
                  end
              
            fun print_graph x 1 G = ()
            |   print_graph x N G = 
                  let
                    val eleme = Array.sub(G, x)
                    fun printList xs =
                      print(String.concatWith ", " (map Int.toString xs))
                  in
                    printList eleme;
                    print("\n");
                    print_graph (x+1) (N-1) G
                  end
            val mark   = Array.array(N+1, false)
            val parent = Array.array(N+1, ~1)
            val count  = Array.array(1, 0)
            val found  = Array.array(1, false)
            val is_in  = Array.array(N+1, false)
            val c_size = Array.array(1, 0)
            val cycle  = Array.array(1, [])
            fun collect v last =
              if v = last then []
              else (
                Array.update(is_in, v, true);
                Array.update(c_size, 0, Array.sub(c_size, 0)+1);
                [v] @ collect (Array.sub(parent, v)) last
              )
            fun dfs v  =
              let
                val counter = Array.sub(count, 0)
                fun helper []          = ()
                |   helper (ngh::tail) = 
                    if Array.sub(mark, ngh) = false then(
                      Array.update(parent, ngh, v);
                      dfs ngh;
                      helper tail
                    )
                    else if ngh <> Array.sub(parent, v) andalso
                            Array.sub(is_in, v) = false andalso
                            Array.sub(found, 0) = false then (
                      let
                        val save_cicle = collect v (Array.sub(parent, ngh))
                      in
                        Array.update(cycle, 0, save_cicle);
                        Array.update(found, 0, true);
                        helper tail
                      end
                    )
                    else (
                      helper tail
                    );
              in (
                Array.update(count,0, counter+1);
                Array.update(mark, v, true);
                helper (Array.sub(G, v))
              )  
              end
          in
            if N <> M then (print "NO CORONA\n"; emptier filename (2*M) )
            else (
              create M G;
              dfs 1;
              if Array.sub(count, 0) = N then 
                let
                  val mark2 = Array.array(N+1, false)
                  val part_sum = Array.array(1, 1)
                  fun dfs2 v  =
                    let
                      fun helper []          = ()
                      |   helper (ngh::tail) = 
                            if Array.sub(mark2, ngh) = false andalso
                               Array.sub(is_in, ngh) = false then (
                                 Array.update(part_sum, 0, (Array.sub(part_sum, 0)+1));
                                 dfs2 ngh;
                                 helper tail
                            )
                            else
                              helper tail
                    in (
                        Array.update(mark2, v, true);
                        helper (Array.sub(G, v))
                        )   
                    end
                  fun worker []        = [] 
                  |   worker (x::tail) = (
                          Array.update(part_sum, 0, 1);
                          dfs2 x;
                          [Array.sub(part_sum,0)] @ worker tail
                        )
                in (
                  print "CORONA ";
                  print(Int.toString(Array.sub(c_size, 0))); print "\n";
                  print_list (worker (Array.sub(cycle, 0))) )
                end
              else print "NO CORONA\n"
            );
            repeater (T-1) filename
          end
  in
    repeater T filename
  end