#include <stdio.h> 
#include <stdlib.h> 

int main() {
  int X = 3;
  int Y = 2;
  int Z = 2;
  int *matrix = (int *) malloc(X * Y * Z * sizeof(int));
  int matrix2 [X][Y][Z];
  
  int x;
  int y;
  int z;
  int k = 0;

  for (x = 0; x < X; x++)
    for (y = 0; y < Y; y++) 
      for (z = 0; z < Z; z++) {
	matrix2[x][y][z] = k++;
	*(matrix + (x * Y + y) * Z + z) = matrix2[x][y][z];
      }
  printf("--------matrix 1 (3 cycles)------\n");
  for (x = 0; x < X; x++)
    for (y = 0; y < Y; y++) {
      for (z = 0; z < Z; z++) 
	printf(" %2d ", *(matrix + (x * Y + y) * Z + z));
      printf("\n");
    }

  printf("--------matrix 1------\n");
  int i = 0;
  printf(" %2d ", *(matrix + i));
  for (i = 1; i < X * Y * Z; i++) {
    if ((i % Z) == 0)
      printf("\n");
    printf(" %2d ", *(matrix + i));
  }
     
  printf("\n--------matrix 2------\n");
  for (x = 0; x < X; x++)
    for (y = 0; y < Y; y++) {
      for (z = 0; z < Z; z++) 
	printf(" %2d ", matrix2[x][y][z]);
      printf("\n");
    }
  

  /*
  printf("--------matrix 1------\n");
  for (x = 0; x < X; x++) {
    for (y = 0; y < Y; y++) 
      printf(" %2d ", *(matrix + x * Y + y));    
    printf("\n");
  }


  printf("--------matrix 2------\n");
  for (x = 0; x < X; x++) {
    for (y = 0; y < Y; y++) 
      printf(" %2d ", matrix2[x][y]);    
    printf("\n");
  }
  */    
  printf("programa terminou\n");
  return 0;
}
