import numpy
from gnuradio import gr
sps=3 #samples per symbol (or oversampling factor)
DCgain=20.0 #gain at DC in frequency domain
Rsym=500.0 #symbol rate (bauds)
Fs=Rsym*sps #sampling frequency (Hz)
rolloff=0.35 #rolloff factor (denoted as "alpha")
ntaps=13 #number of filter taps (must be an odd number)
rrcFilter=gr.firdes.root_raised_cosine(DCgain,Fs,Rsym,rolloff,ntaps)
numpy.savetxt('RRCfilter.txt',rrcFilter) #save as ASCII file
