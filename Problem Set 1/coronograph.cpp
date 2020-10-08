#include <iostream>
#include <vector>
#include <stack>
#include <bits/stdc++.h>
using namespace std;

class Graph {
  private:
    int V;
    int count;
    bool found;
    vector<int> *adj;       
    vector<int> parent; 
    vector<int> cycle;
    vector<int> trees;
    vector<bool> mark;
    vector<bool> in_c;
    void find_cycle(int v);
    void result();
    void aux_dfs(int v);
  public:
    Graph(int N);
    void addEdge(int v1, int v2);
    void corona();
    void clear();
};

Graph::Graph(int N) {
  V = N;
  count = 0;
  found = false;
  adj = new vector<int>[V+1];
  parent.resize(V+1, 0);
  mark.resize(V+1, false);
  in_c.resize(V+1, false);
}

void Graph::addEdge(int v1, int v2) {
  adj[v1].push_back(v2);
  adj[v2].push_back(v1);
}

void Graph::corona() {
  find_cycle(1);
  if(!found) {
    printf("NO CORONA\n");
    return;
  }
  found = false;
  mark.assign(V+1, false);
  parent.assign(V+1, 0);
  result();
}

void Graph::find_cycle(int v) {
  stack<int> stack;
  stack.push(v);
  while(!stack.empty() && !found) {
    v = stack.top();
    stack.pop();
    if(!mark[v])
      mark[v] = true;
    for(auto i = adj[v].begin(); i < adj[v].end(); ++i)
      if(!mark[*i]) {
        stack.push(*i);
        parent[*i] = v;
      }
      else if(parent[v] != *i) {
        do {
          cycle.push_back(v);
          in_c[v] = true;
          v = parent[v];
        } while(v != parent[*i]);
        found = true;
        break;
      }
  }
}

void Graph::result() {
  vector<int>::iterator i;
  for(i = cycle.begin(); i < cycle.end(); i++) {
    trees.push_back(0);
    aux_dfs(*i);
    if(found) break;
  }
  if(found || V != 0)
    printf("NO CORONA\n");
  else {
    printf("CORONA %lu\n", cycle.size());
    sort(trees.begin(), trees.end());
    for(i = trees.begin(); i < trees.end()-1; ++i)
      printf("%d ", *i);
    printf("%d\n", *i);
  }
}

void Graph::aux_dfs(int v) {
  stack<int> stack;
  stack.push(v);
  while(!stack.empty() && !found) {
    v = stack.top();
    stack.pop();
    V--;
    trees.back()++;
    if(!mark[v])
      mark[v] = true;
    for(auto i = adj[v].begin(); i < adj[v].end(); ++i)
      if(!in_c[*i]) {
        if(!mark[*i]) {
          stack.push(*i);
          parent[*i] = v;
        }
        else if(parent[v] != *i) {
          found = true;
          break;
        }
      }
  }
}

void Graph::clear() {
  std::vector<int>().swap(parent);
  std::vector<int>().swap(cycle);
  std::vector<int>().swap(trees);
  std::vector<bool>().swap(mark);
  std::vector<bool>().swap(in_c);
}

void fix (int M, FILE* input) {
  int t;
  for(int i = 0; i < M; ++i)
    t = fscanf(input, "%d", &t);
}

int main(int argc, char **argv) {
  int T, N, M;
  int v1, v2;
  int w;
  FILE* input = fopen(argv[1], "r");

  w = fscanf(input, "%d", &T);
  for(int i = 0; i < T; ++i) {
    w = fscanf(input, "%d", &N);
    w = fscanf(input, "%d", &M);
    if(N != M) {
      printf("NO CORONA\n");
      fix(2*M, input);
      continue;
    }
    Graph G(N);
    for(int j = 0; j < M; ++j) {
      w = fscanf(input, "%d", &v1);
      w = fscanf(input, "%d", &v2);
      G.addEdge(v1, v2); 
    }
    G.corona();
    G.clear();
  }
  w -= 0;
  return 0;
}