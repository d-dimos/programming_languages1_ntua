#!/usr/bin/env python
# coding: utf-8

import sys
from collections import deque

input_file = sys.argv[1]
stream = open(input_file, 'r')
grid = []

for row in stream:
    grid.append(['X']+ list(row.rstrip())+['X'])

M = len(grid[0])

pad = ['X' for i in range (M)]
grid.append(pad)
grid.insert(0,pad)

N = len(grid)
A = []

for i in range(N):
    for j in range(M):
        if grid[i][j] == 'S':
            S = (i,j)
        if grid[i][j] == 'T':
            T = (i,j)
        if grid[i][j] == 'W':
            W = (i,j)
        if grid[i][j] == 'A':
            A.append((i,j))

visited = [['X' for x in range(M)] for y in range(N)]
virus = [[0 for x in range(M)] for y in range(N)]

queueS = deque()
queueW = deque()
queueA = deque()

queueS.append(S)
queueW.append(W)
visited[S[0]][S[1]] = 'S'
visited[W[0]][W[1]] = 'W'

clock = 1
timer = 5
in_air = False
solvable = False

while queueS and not solvable:    
    if clock%2 != 0:
        listA = deque()
        while queueA:
            x, y = queueA.popleft()
            if grid[x+1][y] != 'X' and visited[x+1][y] == 'X':
                visited[x+1][y] = 'H'
                listA.append((x+1,y))
            if grid[x][y-1] != 'X' and visited[x][y-1] == 'X':
                visited[x][y-1] = 'H'
                listA.append((x,y-1))
            if grid[x][y+1] != 'X' and visited[x][y+1] == 'X':
                visited[x][y+1] = 'H'
                listA.append((x,y+1))
            if grid[x-1][y] != 'X' and visited[x-1][y] == 'X':
                visited[x-1][y] = 'H'
                listA.append((x-1,y))
        queueA = listA
        
    if clock%2 == 0:
        listW = deque()
        while queueW:
            x, y = queueW.popleft()
            if grid[x+1][y] != 'X' and virus[x+1][y] == 0:
                if visited[x+1][y] == 'X':
                    visited[x+1][y] = 'Z'
                if visited[x+1][y] == 'Z' or not in_air:
                    listW.append((x+1,y))
                    virus[x+1][y] = 1
                    if grid[x+1][y] == 'A':
                        in_air = True
            if grid[x][y-1] != 'X' and virus[x][y-1] == 0:
                if visited[x][y-1] == 'X':
                    visited[x][y-1] = 'Z'
                if visited[x][y-1] == 'Z' or not in_air:
                    listW.append((x,y-1))
                    virus[x][y-1] = 1
                    if grid[x][y-1] == 'A':
                        in_air = True
            if grid[x][y+1] != 'X' and virus[x][y+1] == 0:
                if visited[x][y+1] == 'X':
                    visited[x][y+1] = 'Z'
                if visited[x][y+1] == 'Z' or not in_air:
                    listW.append((x,y+1))
                    virus[x][y+1] = 1
                    if grid[x][y+1] == 'A':
                        in_air = True
            if grid[x-1][y] != 'X' and virus[x-1][y] == 0:
                if visited[x-1][y] == 'X':
                    visited[x-1][y] = 'Z'
                if visited[x-1][y] == 'Z' or not in_air:
                    listW.append((x-1,y))
                    virus[x-1][y] = 1
                    if grid[x-1][y] == 'A':
                        in_air = True
        queueW = listW
        
    listS = deque()
    while queueS and not solvable:
        x, y = queueS.popleft()
        if grid[x+1][y] != 'X' and visited[x+1][y] == 'X':
            visited[x+1][y] = 'D'
            listS.append((x+1,y))
            if grid[x+1][y] == 'T':
                solvable = True
        if grid[x][y-1] != 'X' and visited[x][y-1] == 'X':
            visited[x][y-1] = 'L'
            listS.append((x,y-1))
            if grid[x][y-1] == 'T':
                solvable = True
        if grid[x][y+1] != 'X' and visited[x][y+1] == 'X':
            visited[x][y+1] = 'R'
            listS.append((x,y+1))
            if grid[x][y+1] == 'T':
                solvable = True
        if grid[x-1][y] != 'X' and visited[x-1][y] == 'X':
            visited[x-1][y] = 'U'
            listS.append((x-1,y))
            if grid[x-1][y] == 'T':
                solvable = True
    queueS = listS
            
    if timer == 0:
        for a in A:
            queueA.append(a)
            if visited[a[0]][a[1]] == 'X':
                visited[a[0]][a[1]] = 'H'
    if in_air:
        timer = timer - 1
    clock = (clock + 1) % 4
    
steps = 0
answer = []
x = T

if solvable:
    while x != S:
        move = visited[x[0]][x[1]]
        answer.append(move)
        steps = steps + 1
        if move == 'U': x = (x[0]+1,x[1])
        elif move == 'R': x = (x[0],x[1]-1)
        elif move == 'L': x = (x[0],x[1]+1)
        else: x = (x[0]-1,x[1])
    answer.reverse()
    print(steps)
    print("".join(answer))
else:
    print("IMPOSSIBLE")
