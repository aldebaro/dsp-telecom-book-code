function isNotSilence=endpointsDetector(x,L,S,silenceThresholddB)
% function isNotSilence=endpointsDetector(x,L,S,silenceThresholddB)
%Returns a vector with elements 0 for silence and 1 for speech, and
%length M=ceil((length(x)-L)/S). Inputs:
%x is the input real signal
%L is window length, i.e., number of samples per window (frame)
%S is window shift (in samples)
%silenceThresholddB is the threshold below the maximum power that
%indicates silence.
M=ceil((length(x)-L)/S); %number of frames discarding last one
power=zeros(M,1);
for i=1:M
    firstSample = 1+(i-1)*S;
    lastSample = firstSample + L - 1;
    xf=x(firstSample:lastSample); %extract a frame from target
    power(i)=mean(xf.^2);
end
powerdB=10*log10(power);
maxPower=max(powerdB);
threshold=maxPower-silenceThresholddB;
isNotSilence=powerdB>threshold;
if 1
    clf
    subplot(311),plot(x)
    subplot(312),plot(powerdB), hold on,
    plot(maxPower*ones(size(powerdB)),'r')
    plot(threshold*ones(size(powerdB)),'k')
    subplot(313), plot(isNotSilence,'-x');
end