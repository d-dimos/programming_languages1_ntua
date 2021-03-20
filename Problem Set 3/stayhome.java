import java.io.BufferedReader;
import java.io.FileReader;
import java.io.*;
import java.util.*;


public class StayHome {
    public static void main(final String args[]) throws Exception {
        long startTime = System.nanoTime();
        final File input = new File(args[0]);
        final BufferedReader br = new BufferedReader(new FileReader(input));
        String temp;
        final char[][] world = new char[1000][1000];
        int i = 0;
        while ((temp = br.readLine()) != null) {
            world[i] = temp.toCharArray();
            i++;
        }
        final int N = i;
        final int M = world[0].length;
        final int[][] visited = new int[N][M];
        final char[][] goBack = new char[N][M];
        final int[] sotiris = new int[2];
        final int[] start = new int[2];
        final int[] finalPos = new int[2];
        final Vector<Integer> airports = new Vector<Integer>();
        for (i = 0; i < N; i++)
            for(int j = 0; j < M; j++)
            {
                visited[i][j] = -1;
                goBack[i][j] = 'q';
                if (world[i][j] == 'S')
                {
                    sotiris[0] = i;
                    sotiris[1] = j;
                }
                if (world[i][j] == 'T')
                {
                    finalPos[0] = i;
                    finalPos[1] = j;
                }
                if (world[i][j] == 'W')
                {
                    start[0] = i;
                    start[1] = j;
                }
                if (world[i][j] == 'A')
                {
                    airports.add(i);
                    airports.add(j);
                }    
            }
            // System.out.println(airports);
        final Queue<Integer> corona = new ArrayDeque<>();
        corona.add(start[0]);
        corona.add(start[1]);
        final Queue<Integer> airqueue = new ArrayDeque<>();
        int tempo = 0;
        while (tempo < airports.size()) {
            airqueue.add(airports.get(tempo));
            airqueue.add(airports.get(tempo + 1));
            tempo += 2;
        }
        final Queue<Integer> sotirisq = new ArrayDeque<>();
        sotirisq.add(sotiris[0]);
        sotirisq.add(sotiris[1]);
        int time = 1;
        int timeReachedAirport = -1;
        visited[start[0]][start[1]] = 2;
        visited[sotiris[0]][sotiris[1]] = 1;
        boolean toBreak = false;
        boolean jobDone = false;
        boolean airflag = false;
        final int[] spot = new int[2];
        Vector<Integer> nextSpots = new Vector<Integer>();
        int b = 0;
        final Queue<Integer> toCorona = new ArrayDeque<>();
        final Queue<Integer> toAirqueue = new ArrayDeque<>();
        final Queue<Integer> toSotirisq = new ArrayDeque<>();

        while (corona.size() != 0 || airqueue.size() != 0 || sotirisq.size() != 0) {
            if (time % 2 == 0) {
                while (corona.size() != 0) {
                    if (toBreak == true)
                        break;
                    spot[0] = corona.remove();
                    spot[1] = corona.remove();
                    nextSpots = nextSpot(spot[0], spot[1], N, M, world);
                    b = 0;
                    while (b < nextSpots.size()) {
                        if (visited[nextSpots.get(b)][nextSpots.get(b + 1)] == -1
                                || visited[nextSpots.get(b)][nextSpots.get(b + 1)] == 1) {
                            visited[nextSpots.get(b)][nextSpots.get(b + 1)] = 2;
                            toCorona.add(nextSpots.get(b));
                            toCorona.add(nextSpots.get(b + 1));
                        }
                        if (world[nextSpots.get(b)][nextSpots.get(b + 1)] == 'A' && airflag == false) {
                            airflag = true;
                            timeReachedAirport = time + 5;
                        }
                        if (world[nextSpots.get(b)][nextSpots.get(b + 1)] == 'T') {
                            System.out.println("IMPOSSIBLE");
                            // System.out.println(time);
                            toBreak = true;
                            break;
                        }
                        b += 2;
                    }
                }
                while (toCorona.size() != 0)
                    corona.add(toCorona.remove());
            }
            if (airflag == true && timeReachedAirport == time) {
                int a = 0;
                while (a < airports.size()) {
                    if (visited[airports.get(a)][airports.get(a + 1)] == -1) {
                        visited[airports.get(a)][airports.get(a + 1)] = 2;
                        toAirqueue.add(airports.get(a));
                        toAirqueue.add(airports.get(a + 1));
                    }
                    a += 2;
                }
                while (toAirqueue.size() != 0)
                    airqueue.add(toAirqueue.remove());
            }
            if (airflag == true && time > timeReachedAirport && time % 2 == 1) {
                while (airqueue.size() != 0) {
                    if (toBreak == true)
                        break;
                    spot[0] = airqueue.remove();
                    spot[1] = airqueue.remove();
                    nextSpots = nextSpot(spot[0], spot[1], N, M, world);
                    b = 0;
                    while (b < nextSpots.size()) {
                        if (visited[nextSpots.get(b)][nextSpots.get(b + 1)] == -1) {
                            visited[nextSpots.get(b)][nextSpots.get(b + 1)] = 2;
                            toAirqueue.add(nextSpots.get(b));
                            toAirqueue.add(nextSpots.get(b + 1));
                        }
                        if (world[nextSpots.get(b)][nextSpots.get(b + 1)] == 'T') {
                            System.out.println("IMPOSSIBLE");
                            // System.out.println(time);
                            toBreak = true;
                            break;
                        }
                        b += 2;
                    }
                }
                while (toAirqueue.size() != 0)
                    airqueue.add(toAirqueue.remove());
            }
            if (toBreak == true)
                break;
            while (sotirisq.size() != 0) {
                if (toBreak == true)
                    break;
                spot[0] = sotirisq.remove();
                spot[1] = sotirisq.remove();
                nextSpots = nextSpot(spot[0], spot[1], N, M, world);
                b = 0;
                while (b < nextSpots.size()) {
                    if (visited[nextSpots.get(b)][nextSpots.get(b + 1)] == -1) {
                        visited[nextSpots.get(b)][nextSpots.get(b + 1)] = 1;
                        toSotirisq.add(nextSpots.get(b));
                        toSotirisq.add(nextSpots.get(b + 1));
                        goBack[nextSpots.get(b)][nextSpots.get(b + 1)] = positionLetter(spot[0], spot[1],
                                nextSpots.get(b), nextSpots.get(b + 1));
                    }
                    if (world[nextSpots.get(b)][nextSpots.get(b + 1)] == 'T') {
                        jobDone = true;
                        toBreak = true;
                        break;
                    }
                    b += 2;
                }
            }
            while (toSotirisq.size() != 0)
                sotirisq.add(toSotirisq.remove());
            time++;
        }
        if (jobDone == true) {
            System.out.println(time - 1);
            finish(goBack, finalPos[0], finalPos[1]);
        }
        // long endTime   = System.nanoTime();
        // long totalTime = endTime - startTime;
        // System.out.println(totalTime/1000000000.0);
    }

    private static Vector<Integer> nextSpot(final int x, final int y, final int N, final int M, final char world[][]) {
        final Vector<Integer> v = new Vector<Integer>();
        if (x + 1 < N && world[x + 1][y] != 'X') {
            v.add(x + 1);
            v.add(y);
        }
        if (y > 0 && world[x][y - 1] != 'X') {
            v.add(x);
            v.add(y - 1);
        }
        if (y + 1 < M && world[x][y + 1] != 'X') {
            v.add(x);
            v.add(y + 1);
        }
        if (x > 0 && world[x - 1][y] != 'X') {
            v.add(x - 1);
            v.add(y);
        }
        return v;
    }

    private static char positionLetter(final int x, final int y, final int nx, final int ny) {
        if (x == nx) {
            if (y == ny + 1)
                return 'L';
            else
                return 'R';
        }
        if (x == nx + 1)
            return 'U';
        else
            return 'D';
    }

    private static void finish(final char goBack[][], int x, int y) {
        final Vector<Character> temp = new Vector<Character>();
        while (goBack[x][y] != 'q')
        {
            temp.add(goBack[x][y]);
            if (goBack[x][y] == 'R')
                y = y - 1;
            else if (goBack[x][y] == 'L')
                y = y + 1;
            else if (goBack[x][y] == 'U')
                x = x + 1;
            else if (goBack[x][y] == 'D')
                x = x - 1;
        }
        Collections.reverse(temp);
        // System.out.println(temp.size());
        for (int i = 0; i < temp.size(); i++)
        {
            System.out.print(temp.get(i));
        }
        System.out.print("\n");
    }
}
