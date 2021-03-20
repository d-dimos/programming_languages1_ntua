#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from collections import deque
import time
import sys

# =============================================================================
# start_time = time.time()
# =============================================================================

def reverse (a):
    if len(a) == 1:
        return a
    else  :
        return a[::-1]

def canPush (state, val):
    if not state[2]:
        return val == state[0][0] or val not in state[3]
    else:
        return comp[val] == state[0][0] or comp[val] not in state[3]

def push (state, val):
    b = state[0]
    c = state[1]
    d = state[2]
    e = state[3].copy()
    if not state[2] :
        if b[0] != val:
            b = val + b
    else:
        if b[0] != comp[val] :
            b = comp[val] + b
    e.add(b[0])
    return [b,c,d,e]
    
comp = \
{
    "A": "U",
    "U": "A",
    "G": "C",
    "C": "G"
}   

inputFile = open("vaccine.in1")
text = inputFile.read().split('\n')


for y in range(int(text[0])):
    stack1 = deque(list(text[y+1]))
    stack2 = stack1.pop()
    start = [stack2,'p',False,set(stack2[0])]

    q = deque([start])

    sol = []
    newIt = 1
    while len(stack1) != 0 :

        val = stack1.pop()
        iterations = newIt
        newIt = 0
        
        for x in range(iterations):
            front = q.popleft()
            

            front1 = [front[0],front[1],front[2],front[3].copy()]
            if canPush(front1, val) :
                temp = push(front1, val)
                temp[1] += "p"
                if len(stack1) != 0 :
                    q.append(temp)
                else:
                    sol.append(temp[1])
                newIt += 1

            front1 = [front[0],front[1],front[2],front[3].copy()]
            if len(front1[0]) > 1 :
                front1[0] = reverse(front1[0])
                if canPush(front1, val) :
                    temp = push(front1, val)
                    temp[1] += "rp"
                    if len(stack1) != 0 :
                        q.append(temp)
                    else:
                        sol.append(temp[1])
                    newIt += 1
          
                    
            front1 = [front[0],front[1],not front[2],front[3].copy()]

            if canPush(front1, val):
                temp = push(front1, val)
                temp[1] += "cp"
                if len(stack1) != 0 :
                    q.append(temp)
                else:
                    sol.append(temp[1])
                newIt += 1

                
            front1 = [front[0],front[1],not front[2],front[3].copy()]
            if len(front1[0]) > 1 :
                front1[0] = reverse(front1[0])

                if canPush(front1, val):
                    temp = push(front1, val)
                    temp[1] += "crp"
                    newIt += 1
                    if len(stack1) != 0 :
                        q.append(temp)
                    else:
                        sol.append(temp[1])

    
    
    sol.sort(key = len)

    toPrint = sol[0]

    if (y == 6) :
        print(sol)
    
    for x in sol :
        if len(toPrint) < len(x):
            break
        
        if x < toPrint :
            toPrint = x     
            
    print(toPrint)
