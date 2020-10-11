
# Assignment 2

### Problem 1: Powers of 2 (Prolog Implementation)
The required programs must:

- read T integer pairs (N, K)
- for each pair in the order they are given, print the lexicographically smallest way that **N** can be written as a sum of exactly **K** powers of 2
- or print an empty list if that is impossible.

### Problem 2: Coronagraphs (Prolog Implementation)
The required programs must:

- read T graph descriptions (the given graph form is explained in the statements)
- check if the given graph contains exactly one circle and no other
  - if it does, then print "CORONA a1, a2, a3...", where a1,a2,a3... are the numbers of children of each subtree whose root is a circle node, sorted from smallest to largest
  - else, print "NO CORONA"

### Problem 3: Stay Home (SML & Python Implementations)
The required programs must examine a given map (a grid of squares) and decide if Sotiris can reach his house (a specific square) before an expanding virus reaches far enough to infect him.
- Sotiris moves one step up, down, left or right on each time unit, walking only on non-infected squares
- The virus expands on all directions possible every two time units, infecting the squares it reaches
- If the virus reaches an airport, then after 5 time units have passed the virus infects all the airports of the map


**INPUT**:
A 2-D grid, whose squares contain one of the following characters:
 - **S**: Sotiris's starting square
 - **T**: Sotiris's house
 - **W**: square from which a virus is poured out
 - **A**: airport
 - **.**: simple square
 - **X**: wall square (neither Sotiris nor the virus can enter)
 
 **OUTPUT**:
 If Sotiris can reach his house before the virus gets to him, then the output is:
 - the shortest (on tie, it prints the lexicographically smallest) sequence of steps he needs to follow
 - else the program must print "IMPOSSIBLE".
