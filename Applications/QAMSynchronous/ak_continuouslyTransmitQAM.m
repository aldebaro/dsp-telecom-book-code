%non-stopping transmission of QAM through the sound board DAC
%The bits are organized in frames, with a preamble.

dt_setGlobalConstants %set global variables
global showPlots txBitStream tailLength;

showPlots=0;
%use the same data for all frames, to simplify BER estimation
temp=rand(Nbits,1); %random numbers ~[0,1]
txBitStream=temp>0.5; %bits: 0 or 1
tailLength = 10; %add this number of symbols at the end of each frame

%create a preamble based on a M-sequence. The code is from:
%Code\MatlabThirdPartyFunctions\mseq.m
preambleLength = 1023; %approximate number of preamble samples
powerVal=floor(log2(preambleLength+1)); %needs to be a power of 2
preamble=mseq(2,powerVal);
preambleLength=length(preamble) %update the length value
Ec=mean(abs(const).^2); %energy constellation in Joules
preamble = sqrt(Ec/mean(abs(preamble).^2))*preamble;%normalize energy
%cannot send preamble like that because it has too large BW
upsampledPreamble=zeros(1,preambleLength*L); %pre-allocate space
upsampledPreamble(1:L:end)=preamble ; %complete upsampling operation

baud = Fs/L  %symbol rate (bauds)
gross_rate_bps=baud*b  %total rate (bps), information and overhead
net_rate_bps=gross_rate_bps*(S/(S+preambleLength+tailLength)) %infor.
while 1 %eternal loop. Break it with CTRL + C
    %slice the bits into the symbol indices:
    symbolIndicesTx = [ak_sliceBitStream(txBitStream, b) ...
        zeros(1,tailLength)]; %add the tail, always the first symbol
    symbols=const(symbolIndicesTx+1); %random symbols
    x=zeros(1,(S+tailLength)*L); %pre-allocate space
    x(1:L:end)=symbols; %complete upsampling operation
    %Add preamble. Obs: if QAM, yce is the complex envelope.
    yce=conv(htx,[upsampledPreamble x]);%convolution by shaping pulse
    %modulate by carrier at wc rad:
    n=0:length(yce)-1; %"time" axis
    s=real(yce .* exp(j*wc*n)); %transmitted signal
    s=s(:); %use column vector
    %psd(s); pause
    sound(s,Fs); %send to the sound board DAC, do not use soundsc
end