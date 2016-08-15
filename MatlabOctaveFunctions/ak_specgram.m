function [newb,f,newt]=ak_specgram(x,filterBWInHz,samplingFrequency,windowShiftInms,thresholdIndB)
%function [newb,f,newt]=ak_specgram(x,filterBWInHz,samplingFrequency,windowShiftInms,thresholdIndB)
%suggested threshold=120; maximum - threshold is floor value
%Example:
%x=randn(1,1000); %white noise
%[b,f,t]=ak_specgram(x,80,16000,1,120);
%imagesc(t,f,b);axis xy; colormap(jet)
%xlabel('seconds'); ylabel('Hz');
%
%Aldebaro Klautau - Dec. 2007

if nargin == 1
    disp('Assuming default values:');
    filterBWInHz=80
    samplingFrequency=11025
    windowShiftInms=1
    thresholdIndB=120
end

preemphasisCoefficient = 0.9;
y=filter([1 -preemphasisCoefficient],1,x);

%BW = 2*fs / HanningWindowLength
HanningWindowLength = round(2*samplingFrequency/filterBWInHz);
%nfft = HanningWindowLength * 2;
nfft = HanningWindowLength;

%noverlap is the number of samples the sections overlap.
%noverlap = round(2/3*HanningWindowLength);
noverlap = HanningWindowLength - round(windowShiftInms*1e-3*samplingFrequency);
if (noverlap >= HanningWindowLength)
   noverlap = HanningWindowLength - 1;
else
   if (noverlap < 0)
	   noverlap = 0;
   end
end

[b,f,t]=specgram(y,nfft,samplingFrequency,HanningWindowLength,noverlap);
b=20*log10(abs(b));
maximum = max(b(:));
minimum = maximum - thresholdIndB;
%Matlab takes care of -Inf also
b(find(b<minimum))=minimum;
%imagesc(b');

%find a slightly different time axis. the new axis adds the amount
%(HanningWindowLength/2)/samplingFrequency
%to the t vector found by specgram. This is just for better positioning.
nshift = HanningWindowLength - noverlap;
t0 = HanningWindowLength / 2;
t1 = t0 + (length(t) - 1) * nshift;
newt = linspace(t0/samplingFrequency,t1/samplingFrequency,length(t));
%make it a column vector to have the same dimension of t:
newt = transpose(newt); 

if (nargout == 0) 
   imagesc(newt,f,b);axis xy; colormap(jet)
   xlabel('seconds'); ylabel('Hz');
else
   %if nargout is 0, avoid having newb printed out because it is undefined
   %but in this case we want newb to be passed to the caller
   newb = b;
end
