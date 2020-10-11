# Assignment 3

### Problem 1: Stay Home (Java Implementation)
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
 - the shortest (on tie, the lexicographically smallest) sequence of steps he needs to follow
 - else the word "IMPOSSIBLE".


### Problem 2: Vaccine (Python, Java & Prolog Implementations)
