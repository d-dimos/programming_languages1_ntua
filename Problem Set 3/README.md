# Assignment 3

### Problem 1: Stay Home ☣️ (Java Implementation)
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


### Problem 2: Vaccine :syringe: (Python, Java & Prolog Implementations)

The program is required to "print the vaccine" that kills the virus of the "Stayhome problem".

Given a stack of RNA nitrogenous bases ("A", "U", "G", "C"), we consider the following possible moves that we can do, in order to create another stack in which all the nitrogenous bases of the given stack are in groups (all "A"s together, all "T"s together and so on). The moves are:

- "p" (push): removes the top base from the given stack and puts it on top of the new stack 
- "c" (comlement): replaces all the bases from the given stack with their complementary ones ("A" :left_right_arrow: "U", "C" :left_right_arrow: "G")
- "r" (reverse): turns the new stack's content upside-down

The program must print the shortest (on a tie, the lexicographicaly smallest) sequence of moves (the desired vaccine) that need to be done, in order the create the above mentioned stack. (It can be proven that for every given sequence of bases, there is at least one possible sequence of moves that results in a valid vaccine)
