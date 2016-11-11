x=(1:4)+j*(4:-1:1); %define some complex signals as row vectors, such
y=rand(1,15)+j*rand(1,15); %that fliplr inverts the ordering
%% Correlation via convolution
Rref=xcorr(x,y); %reference of a cross-correlation
xcorrViaConv=conv(x,conj(fliplr(y))); %use the second argument
%% Convolution via correlation
Cref=conv(x,y); %reference of a convolution
convViaXcorr=xcorr(x,conj(fliplr(y))); %using the second argument
%convViaXcorr=conj(fliplr(xcorr(conj(fliplr(x)),y))); %alternative
%% Make sure they have the same length and compare the results
if length(x) ~= length(y) %this case requires post-processing because
    %xcorr assumes the sequences have the same length and uses
    %zero-padding if they do not. We treat the effect of these zeros:
    convolutionLength=length(x)+length(y)-1;
    correlationLength=2*max(length(x),length(y))-1;
    if length(x) < length(y) %zeros at the end
        convViaXcorr = convViaXcorr(1:convolutionLength);
        xcorrViaConv = [xcorrViaConv zeros(1,correlationLength- ...
            length(xcorrViaConv))];
    elseif length(x) > length(y) %zeros at the beginning
        convViaXcorr = convViaXcorr(end-convolutionLength+1:end);
        xcorrViaConv = [zeros(1,correlationLength- ...
            length(xcorrViaConv)) xcorrViaConv];
    end
end
ErroXcorr= max(abs(Rref - xcorrViaConv)) %calculate maximum errors
ErroConv = max(abs(Cref - convViaXcorr)) %should be small numbers
