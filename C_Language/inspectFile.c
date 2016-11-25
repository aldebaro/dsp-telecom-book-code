/* Prints each byte of a file */
#include <stdio.h>
#include <stdlib.h>
#define DATE    "Aldebaro. Nov/24/2016"
int main(int argc, char  *argv[]) {
	FILE    *fp;
	int     k,i,j,k2;
	unsigned char x1;
	char    s[4096]; 
	puts(DATE);
	if(argc!=4) {
		printf("Usage: %s <input file> <first byte> <last>\n",argv[0]);
		puts("Example: inspectFile myfile.bin 0 30");
		exit(1);
	}
	sprintf(s,"%s",argv[1]);
	fp=fopen(s,"rb");
	if (fp==NULL) {
		puts("Erro abertura do arquivo");
		exit(1);
	}
	for (i=0;i<atoi(argv[2]);i++) { //skip bytes as specified by user
		fread(&x1,sizeof(unsigned char),1,fp);
	}
	k=0;
	for(i=atoi(argv[2]);i<atoi(argv[3]);i++,k++) {
		k2=fread(&x1,sizeof(unsigned char),1,fp);
		if(k2 != 1) {
			puts("End of file!"); 
			break;
		}
		printf("%d\t%d (decimal)\t%x (hexa)\t(%c)\n",k,(short int)x1,(short int)x1,x1);
	}
	puts("Happy end!");
	fclose(fp);
}
