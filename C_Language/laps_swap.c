/** This code swaps the bytes in order to create a little-endian
    file from a big-endian and vice-versa.
*/
#include <stdio.h>
#include <stdlib.h>

#define DATE	"Aldebaro. March 10, 2009"

int main(int argc, char  *argv[]) {

FILE 	*inputFILEPointer, *outputFILEPointer;
int	numBytes, i, k, k2, counter;
char	x[16]; /*maximum size of an element is 16 bytes*/
char 	s[10240]; /*file name*/

puts(DATE);

if(argc!=4) {
		printf("Usage: <input_file> <output_file> <number_of_bytes_of_each_element>\n");
		printf("Example: in.bin out.bin 4  (for swapping 4 bytes of floats)\n");
		exit(1);
}

sprintf(s,"%s",argv[1]);
inputFILEPointer=fopen(s,"rb");
if(inputFILEPointer==NULL) {
	printf("Error opening file: %s", s);
	exit(1);
}

sprintf(s,"%s",argv[2]);
outputFILEPointer=fopen(s,"wb");
if(outputFILEPointer==NULL) {
	printf("Error opening file: %s", s);
	exit(1);
}

numBytes = atoi(argv[3]);
if (numBytes < 1 || numBytes > 16) {
	puts("The <number_of_bytes_of_each_element> must be in the range from 1 to 16!");
	exit(-1);
}
counter = 0;
do {
	k=fread(&x,1,numBytes,inputFILEPointer);
	/*k is the number of read "elements", in this case bytes*/
	if(k != numBytes) {
		puts("End of file!");
		printf("%d",k);
		break;
	}
	/*write bytes in inverted order*/
	for (i=numBytes-1;i>=0;i--) {
		k2=fwrite(&x[i],1,1,outputFILEPointer);
		if(k2 != 1) {
			printf("Error writing file: %s",s);
			exit(-1);
		}

	}
	counter++;
} while (k==numBytes);

fclose(inputFILEPointer);
fclose(outputFILEPointer);

printf("Happy end. Wrote file %s with %d bytes.\n",s,numBytes*counter);
}

