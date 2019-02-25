#include <mpi.h>
#include <string.h>
#include "encrypt.h"
#include "decrypt.h"
#define MASTER          0

int main(int argc, char *argv[])
{
    MPI_Init (&argc, &argv);
    int taskid, numtasks, ctr, a, source, tag, x, len, check;
    double ti, tf;
    long size, fs;
    char ffl[2];
    char ffd[8];
    char *buf;
    char *buf2;
    char *buf3;
    a = 9;
    ctr = 1;
    tag = 0;
    MPI_Status status;
    MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
    MPI_Comm_rank(MPI_COMM_WORLD, &taskid);
    printf("La tarea MPI Nro. %d ha comenzado...\n", taskid);
    if (taskid == MASTER)
        {
            ti = MPI_Wtime();
            system("split -d -a 1 -b 2m test.mp3");
            printf("El archivo ha sido separado satisfactoriamente...\n");
            for (ctr; ctr < a; ctr++){
		sprintf(ffl, "x%d", ctr - 1);
                FILE *fb;
                fb = fopen(ffl, "rb");
                fseek(fb, 0, SEEK_END);
                size = ftell(fb);
                rewind(fb);
                buf = (char *) malloc((size + 1) * sizeof(char));
                fread(buf, size, 1, fb);
                fclose(fb);
                MPI_Send(&size, 1, MPI_INT, ctr, tag, MPI_COMM_WORLD);
                MPI_Send(&buf[0], size + 1, MPI_CHAR, ctr, tag + 1, MPI_COMM_WORLD);
                sprintf(ffd, "new%d.mp3", ctr - 1);
                FILE *fx;
                fx = fopen(ffd, "wb");
                fseek(fx, 0, SEEK_END);
                rewind(fx);
                buf2 = (char *) malloc((size + 1) * sizeof(char));
                MPI_Recv(buf2, size + 1, MPI_CHAR, ctr, tag + 3, MPI_COMM_WORLD, &status);
                fwrite(buf2, size, 1, fx);
                fclose(fx);
            }
            tf = MPI_Wtime();
            printf("Código de picado y enviado ejecutado en %.5f segundos\n", tf - ti);
        //for (ctr; ctr < a; ctr++){
            MPI_Recv(&check, 1, MPI_INT, MPI_ANY_SOURCE, tag + 2, MPI_COMM_WORLD, &status);
            printf("%d recibió la señal de completación del proceso de %d\n", taskid, status.MPI_SOURCE);
            system("cat new* > ArchivoFinal.mp3");
            //}           
        }
    else if (taskid != MASTER){
        ti = MPI_Wtime();
        sprintf(ffd, "touch new%d.mp3", taskid);
        system(ffd);
        MPI_Recv(&size, 1, MPI_INT, MASTER, tag, MPI_COMM_WORLD, &status);
        printf("%d recibió el tamaño de archivo %d de %d\n", taskid, size, status.MPI_SOURCE);
        char *ff/*, *fll*/;
        ff = (char *) malloc((size + 1));
        MPI_Recv(ff, size + 1, MPI_CHAR, MASTER, tag + 1, MPI_COMM_WORLD, &status);
        printf("%d recibió el buffer de tamaño %d, de %d\n", taskid, size, status.MPI_SOURCE);        
        check = 1;
        encrypt(ff);
	encrypt2(ff);
	encrypt3(ff);
        decrypt(ff);
	decrypt2(ff);
	decrypt3(ff);
        MPI_Send(&ff[0], size + 1, MPI_CHAR, MASTER, tag + 3, MPI_COMM_WORLD);
        MPI_Send(&check, 1, MPI_INT, MASTER, tag + 2, MPI_COMM_WORLD);
        tf = MPI_Wtime();
        printf("Código de encriptado y desencriptado ejecutado en %.5f segundos\n", tf - ti);
    }
    printf("La tarea MPI Nro. %d ha finalizado...\n", taskid);
    printf("\n");
    MPI_Finalize();
}
