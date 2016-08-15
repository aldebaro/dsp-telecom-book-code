inputLengthLog2=6; %the input length is 2^inputLengthLog2-1
inputLength=2^inputLengthLog2-1; %number of input samples
SNRdB = 80; %SNR (dB) that determines noise power. Inf is noiseless
inputSequenceChoice=1; %choose between following options
switch inputSequenceChoice %obs: input signal must be a column vector
    case 1; x=transpose(1:2^inputLengthLog2-1); %arbitrary input
    case 2; x=2*((rand(inputLength,1)>0.5)-0.5); %random
    case 3; x=mseq(2,inputLengthLog2); %"maximum length" sequence
end
alpha = 1/sum(x.^2); %find normalization factor
%% Define the channel. Example: a Chebyshev filter
N=6; R=0.5; Wp=[0.3 0.5]; %order, ripple in dB and cutoff frequencies
[B,A]=cheby1(N,R,Wp); %design filter, obs: can check with freqz(B,A)
h=impz(B,A); %get long h (length determined by impzlength.m)
h_power = abs(h).^2; %instantaneous power of h (assumed in Watts)
h_totalEnergy=sum(h_power); %total energy of h (assumed in Joules)
accumulatedEnergySum = cumsum(h_power); %accumulated sum
energyThreshold = 99.99/100; %keep 99.99% of total energy in h
index=find(accumulatedEnergySum > energyThreshold*h_totalEnergy,1);
h=h(1:index); %truncated impulse response, can check with freqz(h)
%% Pass signal through channel and add noise
y=conv(x,h); %pass input signal through the channel
P_receiver = mean(abs(y).^2); %power of signal of interest at Rx
Power_noise = P_receiver / 10^(0.1*SNRdB); %noise power
y=y+sqrt(Power_noise)*randn(size(y)); %add some noise
X=convmtx(x,length(h)); %create convolution matrix X
mpInv=pinv(X); %pinv is a robust estimation of the pseudoinverse
%% Compare identification techniques:
%1) LS estimate via Moore-Penrose pseudoinverse
h_est = mpInv*y; %use pseudoinverse previously computed
%2) Assuming inv(X'*X) is alpha*I  (where I is the identity matrix)
h_est2 = alpha*X'*y; %under assumption, no need to calculate pinv(X)
%3) Peak-searching procedure with known h peak index (hpeakIndex)
z=conv(y,flipud(x)); %implement crosscorrelation via convolution
[maxOutput, maxIndex] = max(abs(z)); %find peak of output (R)
[temp hpeakIndex] = max(abs(h)); %index of impulse response peak
guessFirstIndex = maxIndex-hpeakIndex+1; %index to get imp. response
h_est3=alpha*z(guessFirstIndex:guessFirstIndex+length(h)-1);%estimate
%% Results:
errors=[h-h_est h-h_est2 h-h_est3]; %estimation error for 3 estimates
disp(['Errors (time domain): ' ...
    num2str(10*log10(mean(abs(errors).^2))) ' (dB)'])
spectralDistort=[ak_spectralDistortion(h,h_est,length(h),10), ...
 ak_spectralDistortion(h,h_est2,length(h),10)... %use 10 dB to get
 ak_spectralDistortion(h,h_est3,length(h),10)]; %passband distortions
disp(['Errors (freq. domain): ' num2str(spectralDistort) ' (dB)'])