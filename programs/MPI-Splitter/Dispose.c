#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#define MASTER      0

int main(int argc, char* argv[]){
    MPI_Init(&argc, &argv);
    int taskid, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &taskid);    
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);
    
    if (taskid == MASTER){
        system("rm x*");
        system("rm new*");
        printf("Se han limpiado los archivos temporales...");
    }

    MPI_Finalize();
}
