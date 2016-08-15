subplot(222); pwelch(yce,[],[],[],Fs); %yce and Fs previously defined
Pyce=pwelch(yce,[],[],[],Fs); %recalculate PSD, store result in Pyce
f=linspace(-Fs/2,Fs/2,length(Pyce)); %create a frequency axis
subplot(224); plot(f,fftshift(10*log10(Pyce))); %from -Fs/2 to Fs/2
