L=3; %oversampling factor (samples per symbol)
r=0.5; %roll-off factor
Dsym=2; %group delay considering the number of input symbols at Rsym
p=ak_rcosine(1,L,'fir/normal',r,Dsym); %normal (not square-root) FIR
ak_plotNyquistPulse(p,L) %plot spectrum replicas in frequency domain
Ds=(length(p)-1)/2;%group delay considering output samples at Fs

