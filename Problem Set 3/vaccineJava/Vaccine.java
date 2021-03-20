import java.util.*; 
import java.lang.*; 
import java.io.*; 
import java.io.BufferedReader;
import java.io.FileReader;


public class Vaccine {
    public static void main(final String args[]) throws Exception {
        final File input = new File(args[0]);
        final BufferedReader br = new BufferedReader(new FileReader(input));

        String temp;

        temp = br.readLine();

        final int iterations = Integer.parseInt(temp);

        for (int a = 0; a < iterations; a++) {
            temp = br.readLine();
            int size = temp.length() - 1;
            final Character current = temp.charAt(size);


            final State start = new State(current.toString(), "p", false/* , in */);

            State tempoo = new State(start);

            final Queue<State> q = new ArrayDeque<>();

            q.add(start);

            int next = 1;
            int iteration;

            while (size != 0) {
                size--;
                final Character val = temp.charAt(size);
                iteration = next;
                next = 0;

                for (int it = 0; it < iteration; it++) {
                    final State state = q.remove();

                    final State tempo = new State(state);


                    if (canPush(tempo, val.toString())) {
                        tempoo = push(tempo, val.toString());
                        tempoo._solution += "p";
                        q.add(tempoo);

                        next++;
                    }

                    tempo.equals(state);
                    if (tempo._str.length() > 1) {
                        tempo._str = reverse(tempo._str);
                        if (canPush(tempo, val.toString())) {
                            tempoo = push(tempo, val.toString());
                            tempoo._solution += "rp";

                            q.add(tempoo);

                            next++;
                        }
                    }

                    tempo.equals(state);
                    tempo._isComplemented = !tempo._isComplemented;
                    if (canPush(tempo, val.toString())) {
                        tempoo = push(tempo, val.toString());
                        tempoo._solution += "cp";

                        q.add(tempoo);

                        next++;
                    }

                    tempo.equals(state);
                    tempo._isComplemented = !tempo._isComplemented;
                    if (tempo._str.length() > 1) {
                        tempo._str = reverse(tempo._str);
                        if (canPush(tempo, val.toString())) {
                            tempoo = push(tempo, val.toString());
                            tempoo._solution += "crp";

                            q.add(tempoo);

                            next++;
                        }
                    }

                }

            }

            final State tem = q.remove();
            String ret = tem._solution;

            while (!q.isEmpty()) {
                final String tempooo = q.remove()._solution;

                if (tempooo.length() < ret.length() || (tempooo.length() == ret.length()) & tempooo.compareTo(ret) < 0)
                    ret = tempooo;

            }
            System.out.println(ret);
            q.clear();

        }

    }

    private static State push(final State state, final String val) {
        final State toRet = new State(state);

        if (!toRet._isComplemented) {
            if (!val.equals(Character.toString(state._str.charAt(0))) || !state._str.contains(val))
                toRet._str = val + toRet._str;
        } else {
            if (!comp(val).equals(Character.toString(state._str.charAt(0))) || !state._str.contains(comp(val)))
                toRet._str = comp(val) + toRet._str;
        }

        return toRet;
    }

    private static Boolean canPush(final State state, final String val) {
        if (!state._isComplemented) {
            return val.equals(Character.toString(state._str.charAt(0))) || !state._str.contains(val);
        } else {
            return comp(val).equals(Character.toString(state._str.charAt(0))) || !state._str.contains(comp(val));
        }
    }

    public static String comp(final String inp) {
        if (inp.equals("A"))
            return "U";
        if (inp.equals("U"))
            return "A";
        if (inp.equals("C"))
            return "G";
        if (inp.equals("G"))
            return "C";
        return "O";
    }

    private static String reverse(final String inp)
    {
        StringBuilder temp = new StringBuilder();
        temp.append(inp);
        // System.out.println(temp);
        temp = temp.reverse();
        // System.out.println(temp);
        return temp.toString();
    }
}
