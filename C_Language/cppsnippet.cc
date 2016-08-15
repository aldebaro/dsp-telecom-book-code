#include "usrp_standard.h"
void process_data(int *buffer,bufsize) {
	for (int i=0; i<bufsize; i++) {
		unsigned short real = (buffer[i] & 0xFFFF0000)>>16; //DDC real output
		unsigned short imag = buffer[i] & 0x0000FFFF; //DDC imaginary output
	}
}
int main (int argc, char **argv) {
	usrp_standard_rx_sptr urx =  usrp_standard_rx::make (which_board, decim, 1,
		-1, mode, fusb_block_size, fusb_nblocks);
	urx->set_rx_freq (0, 2500000000); // DDC frequency
	urx->start(); // init transmission
	for (i = 0; i < total_reads; i++) {//read samples
		urx->read(&buf[0], bufsize, &overrun);
		process_data(&buf[0],bufsize);
	}
	urx->stop();  // stop transmission
	delete urx; return 0;
}

