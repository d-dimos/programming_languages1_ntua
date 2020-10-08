fun exp2 0 = 1
  | exp2 x = 2*(exp2 (x-1))

fun print_list list =
  let
    fun print_help [] = ()
      | print_help [a] = print (Int.toString(a))
      | print_help list = 
        (
          print (Int.toString(hd list));
          print ",";
          print_help (tl list)
        )
  in
      print "["; print_help list; print "]";
      print "\n"
  end

fun floor_log2 x = 
    IntInf.log2 (IntInf.fromInt x)
  
  (*Real.round((Math.log10(Real.fromInt(x)))/(Math.log10(2.0)))*)

fun powers2(input_file: string) =
  let
    val filename = TextIO.openIn input_file
    fun read_num(filename) =
      let
        fun get filename = 
          case TextIO.scanStream(Int.scan StringCvt.DEC) filename
          of SOME int => int
          |  NONE     => 0
      in
        get filename
      end
    val T = read_num filename
    fun repeater 0 filename = ()
      | repeater T filename = 
          let
            val N = read_num filename
            val K = read_num filename
            fun zeros Z = 
              if Z <= 0 then []
              else 0 :: zeros (Z-1);
            
            fun fix_log N K log =
              if (N - (exp2 log)) < (K - 1) then fix_log N K (log-1)
              else log;
            fun algo list 0 0 prev_log = zeros(prev_log) @ list
              | algo list N 0 prev_log = []
              | algo list N K prev_log =
                  if N < K then list
                  else if N = K andalso prev_log <> ~1 then [K] @ zeros(prev_log - 1) @ list
                  else if N = K then [K] @ list
                  else
                    let
                      val max_log = fix_log N K (floor_log2 N)
                      val zerol = zeros(prev_log-max_log-1);
                      val new = zerol @ list
                    in 
                      if max_log = prev_log then
                        algo (((hd new) + 1)::(tl new)) (N-exp2(max_log)) (K-1) max_log
                      else 
                        algo (1::new) (N-exp2(max_log)) (K-1) max_log
                    end
          in
            print_list (algo [] N K ~1);
            repeater (T-1) filename
          end   
  in
    repeater T filename before
    TextIO.closeIn filename
  end
