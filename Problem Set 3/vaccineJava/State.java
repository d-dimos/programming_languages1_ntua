import java.util.*; 
import java.lang.*; 
import java.io.*; 
import java.io.BufferedReader;
import java.io.FileReader;

public class State {
    public String _str;
    public String _solution;
    public Boolean _isComplemented;
    // public HashSet<Character> _inStr;

    public State(final String str, final String solution, final Boolean isComplemented/*, final HashSet<Character> inStr)*/ ) {
        _str = str;
        // _inStr = inStr;
        _isComplemented = isComplemented;
        _solution = solution;
    }

    public State (State s)
    {
        _str = s._str;
        _solution = s._solution;
        _isComplemented = s._isComplemented;
        // _inStr = new HashSet<Character>(s._inStr);
    }

    public State reverse() {
        final State toRet = new State(this);

        StringBuilder temp = new StringBuilder();

        temp.append(_str);
        temp = temp.reverse();
        toRet._str = temp.toString();

        return toRet;
    }

    public void equals (State inp)
    {
        // _inStr = new HashSet<Character>(inp._inStr);
        _isComplemented = inp._isComplemented;
        _solution = inp._solution;
        _str = inp._str;
    }
}
