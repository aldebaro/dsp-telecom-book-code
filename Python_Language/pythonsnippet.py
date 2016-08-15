#source, usrp and modulator
from gnuradio import gr, usrp, blks2
class my_message_source(gr.top_block): #graph file->mod->usrp
	def __init__(self):
		gr.top_block.__init__(self)
		self.source = gr.file_source(gr.sizeof_char, #samples size
			"mensagem.wav", repeat=False)
		mod = blks2.qam8_mod() #QAM modulator
		self.target = u = usrp.sink_c(0)
		#set intermediate frequency (IF)
		res = u.tune(tx[0], #DUC channel
					flexboard,  #daughterboard
					2.5e9) #IF value
		self.connect(self.source, mod, self.target) #connect blocks
if __name__ == '__main__':
	s = my_message_source()
	s.run()

