/* Dump files with each byte interpreted in several formats */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HELLO "Aldebaro Klautau - www.laps.ufpa.br - March 10, 2009"
#define SWAP_SHORT(Var)  Var = *(short*) SwapEndian((void*)&Var, sizeof(short))
#define SWAP_INT(Var)    Var = *(int*) SwapEndian((void*)&Var, sizeof(int))
#define SWAP_LONG(Var)   Var = *(long*) SwapEndian((void*)&Var, sizeof(long))
#define SWAP_FLOAT(Var)  Var = *(float*) SwapEndian((void*)&Var, sizeof(float))
#define SWAP_DOUBLE(Var) Var = *(double*) SwapEndian((void*)&Var, sizeof(double))

void *SwapEndian(void* Addr, const int Nb);

int main(int argc, char* argv[]) {
FILE    *filePointer;
int counter=0;

if(argc!=3) {
	printf("Usage: <input file> <swap|not>\n");
	puts("Use 'swap' in the second argument to swap the bytes or 'not' for not swapping");
	exit(1);
}

puts(HELLO);
puts("Each columns represents:");
puts("<byte counter> <decimal char> <hexa char> <(ASCII)> <short> <int> <long int> <float> <double>\n");

filePointer=fopen(argv[1],"rb");
if(filePointer==NULL) {
	printf("Error opening file %s",argv[1]);
	exit(1);
}

if (strcmp(argv[2],"swap")==0) {
counter = readDataSwappingBytes(filePointer);
} else {
counter = readDataWithoutSwapping(filePointer);
}


fclose(filePointer);
printf("\n\n%d bytes read from file %s\n",counter,argv[1]);
return 1;
}

int readDataWithoutSwapping(FILE *filePointer) {
int     k;
unsigned char xc;
short xs;
int xi;
long int xl;
float xf;
double xd;
int counter=1;
do	{
	k=fread(&xc,sizeof(unsigned char),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(unsigned char), SEEK_CUR);
	printf("%d %d %x (%c) ",counter,(short int)xc,(short int)xc,xc);

        k=fread(&xs,sizeof(short),1,filePointer);
	if(k != 1) { puts("End of file."); break;}
	fseek(filePointer, - (int) sizeof(short), SEEK_CUR);
	printf("%d ",xs);

        k=fread(&xi,sizeof(int),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(int), SEEK_CUR);
	printf("%d ",xi);

        k=fread(&xl,sizeof(long int),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(long int), SEEK_CUR);
	printf("%d ",xl);

        k=fread(&xf,sizeof(float),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(float), SEEK_CUR);
	printf("%e ",xf);

        k=fread(&xd,sizeof(double),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(double), SEEK_CUR);
	printf("%e\n",xd);

	fseek(filePointer, sizeof(unsigned char), SEEK_CUR);
	counter++;
	} while(1);
return counter;
}


int readDataSwappingBytes(FILE *filePointer) {
int     k;
unsigned char xc;
short xs;
int xi;
long int xl;
float xf;
double xd;
int counter=1;

do	{
	k=fread(&xc,sizeof(unsigned char),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(unsigned char), SEEK_CUR);
	printf("%d %d %x (%c) ",counter,(short int)xc,(short int)xc,xc);

        k=fread(&xs,sizeof(short),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(short), SEEK_CUR);
        printf("%d ",SWAP_SHORT(xs));

        k=fread(&xi,sizeof(int),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(int), SEEK_CUR);
	printf("%d ",SWAP_INT(xi));

        k=fread(&xl,sizeof(long int),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(long int), SEEK_CUR);
	printf("%d ",SWAP_LONG(xl));

        k=fread(&xf,sizeof(float),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(float), SEEK_CUR);
	printf("%e ",SWAP_FLOAT(xf));

        k=fread(&xd,sizeof(double),1,filePointer);
	if(k != 1) break;
	fseek(filePointer, - (int) sizeof(double), SEEK_CUR);
	printf("%e\n",SWAP_DOUBLE(xd));

	fseek(filePointer, sizeof(unsigned char), SEEK_CUR);
	counter++;
	} while(1);
return counter;
}

/******************************************************************************
  FUNCTION: SwapEndian
  PURPOSE: Swap the byte order of primitive types
  EXAMPLE: float F=123.456; SWAP_FLOAT(F);
**********************'********************************************************/
void *SwapEndian(void* Addr, const int Nb) {
	static char Swapped[16];
	switch (Nb) {
		case 2:	Swapped[0]=*((char*)Addr+1);
				Swapped[1]=*((char*)Addr  );
				break;
		case 4:	Swapped[0]=*((char*)Addr+3);
				Swapped[1]=*((char*)Addr+2);
				Swapped[2]=*((char*)Addr+1);
				Swapped[3]=*((char*)Addr  );
				break;
		case 8:	Swapped[0]=*((char*)Addr+7);
				Swapped[1]=*((char*)Addr+6);
				Swapped[2]=*((char*)Addr+5);
				Swapped[3]=*((char*)Addr+4);
				Swapped[4]=*((char*)Addr+3);
				Swapped[5]=*((char*)Addr+2);
				Swapped[6]=*((char*)Addr+1);
				Swapped[7]=*((char*)Addr  );
				break;
		case 16:Swapped[0]=*((char*)Addr+15);
				Swapped[1]=*((char*)Addr+14);
				Swapped[2]=*((char*)Addr+13);
				Swapped[3]=*((char*)Addr+12);
				Swapped[4]=*((char*)Addr+11);
				Swapped[5]=*((char*)Addr+10);
				Swapped[6]=*((char*)Addr+9);
				Swapped[7]=*((char*)Addr+8);
				Swapped[8]=*((char*)Addr+7);
				Swapped[9]=*((char*)Addr+6);
				Swapped[10]=*((char*)Addr+5);
				Swapped[11]=*((char*)Addr+4);
				Swapped[12]=*((char*)Addr+3);
				Swapped[13]=*((char*)Addr+2);
				Swapped[14]=*((char*)Addr+1);
				Swapped[15]=*((char*)Addr  );
				break;
	}
	return (void*)Swapped;
}
