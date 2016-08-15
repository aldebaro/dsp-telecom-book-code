p_gnuradio=load('RRCfilter.txt','-ascii'); %load file created by GR
L=3; %samples per symbol (or oversampling factor)
DCgain=20.0 %gain at DC in frequency domain
rolloff=0.35; %rolloff factor (denoted as "alpha")
ntaps=13; %number of filter taps (must be an odd number)
gDelay=(ntaps-1)/(2*L); %group delay (assuming linear phase FIR)
p=rcosine(1,L,'fir/sqrt',rolloff,gDelay); %design square-root FIR
p=DCgain*(p/sum(p)); %gain at DC (sum(p) is the original DC gain)
plot(p_gnuradio,'o-'), hold on, plot(p,'rx-');%compare (should match)