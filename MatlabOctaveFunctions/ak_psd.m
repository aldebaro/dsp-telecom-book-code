function [SdBmHz,f]=ak_psd(x,Fs)
% function [SdBmHz,f]=ak_psd(x,Fs)
%Returns the PSD SdBmHz of x in dBm/Hz in the frequency range
%f=[-Fs/2,Fs/2[. Usage example:
%Fs=100;x=exp(j*2*pi*7/Fs*(0:40000));[S,f]=ak_psd(x,Fs);
%plot(f,S);xlabel('f (Hz)');ylabel('PSD (dBm/Hz)'); %see peak at 7 Hz
N=length(x);
if N > 2048 
    M=round(length(x)/8); %number of samples per block for Welch's
else %use a single FFT in case N is not longer than 2048
    M=length(x);
end
b=nextpow2(M); Nfft=2^b; %choose a power of 2 for FFT-length 
%Obs: Matlab and Octave have distinct syntax for 3rd pwelch parameter
S=pwelch(x,hamming(M),[],Nfft,Fs,'twosided'); %use default overlap
%S=pwelch(x,hamming(M),floor(M/2),Nfft,Fs,'twosided'); %overlap=M/2
df=Fs/Nfft; %FFT frequency spacing
f=-Fs/2:df:Fs/2-df; %frequency (abscissa) axis
S=fftshift(S); %move negative part to the left
S=S*1000; %convert from Watts to mWatts
SdBmHz = 10*log10(S); %provide PSD in dBm/Hz
if nargout == 0
    plot(f,SdBmHz) %plot
end