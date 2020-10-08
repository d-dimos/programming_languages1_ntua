#include <iostream>
#include <math.h>  
using namespace std;

struct node {
  int data;
  node* next;
};
typedef node *list;

void add_zero (list &l, int Z) { // Adds Z zeros to the list
  if(Z <= 0)
    return;
  node *p = new node;
  p -> data = 0;
  p -> next = l;
  l = p;
  add_zero(l, Z - 1);
  return;
}

list new_head (list &l, int M) {  // Adds M at the start of a list
  node *p = new node;
  p -> data = M;
  p -> next = l;
  return p;
}

void print_it (list &to_print) {  // Prints given list
  printf("[");
  if(to_print != NULL) {
    while(to_print->next != NULL) {
      printf("%d,", to_print->data);
      to_print = to_print->next;
    }
    printf("%d", to_print->data);
  }
  printf("]\n");
}

list patata (list &l, int N, int K, int prev_log) {  // Potato
  if(K == 0 && N == 0) {
    add_zero(l, prev_log);
    return l;
  }
  if(K == 0) {
    return NULL;
  }
  if(N < K)
    return l;
  if(N == K && prev_log != -1) {
    add_zero(l, prev_log - 1);
    return new_head(l, K);
  }
  if(N == K) 
    return new_head(l, K);
  int max_log = log2(N);
  while(N - pow(2, max_log) < K - 1)
    --max_log;
  add_zero(l, prev_log - max_log - 1);
  if(max_log == prev_log)
    ++(l -> data);
  else
    l = new_head(l, 1);
  return patata(l, N - pow(2, max_log), K - 1, max_log);
}

int main(int argc, char **argv) {
  int T, N, K, w;
  FILE* input_file = fopen(argv[1], "r");

  w = fscanf(input_file, "%d", &T);
  list result[T];
  for(int i = 0; i < T; ++i) {
    node *p = new node;
    p = NULL;
    w = fscanf(input_file, "%d %d", &N, &K);
    result[i] = patata(p, N, K, -1);
  }
  for(int i = 0; i < T; ++i)
    print_it(result[i]);
  w -= 0;
}
