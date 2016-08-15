%create two sequences: s1 at baud rate and s2 oversampled
OSR=4; %oversampling factor
N1=3; %number of samples of sequence s1
N2=2*OSR*N1; %number of samples of sequence s2
s1 = (1:N1)*(1+j); %at baud rate (OSR=1)
s2 = (1:N2)*(1-0.5*j); %at OSR times baud rate (OSR>1)
%First method - not using the xcorr function
%number of samples of s2 that can be used in correlation:
N = N2-OSR*N1; 
%make s2 a column vector. Prepare for inner product
s2=transpose(s2); 
crossCorrelation = zeros(1,N); %pre-allocate space
for lag = 1:N
    %extract segment of s2 with size and rate equal to s1
    segment = s2(lag:OSR:lag+(N1-1)*OSR);
    crossCorrelation(lag)= s1 * conj(segment);
end
%Second method - using the xcorr function
crossCorrelation2 = zeros(1,N); %pre-allocate space
maximumLag = floor(N/OSR)-1; %limit xcorr's maximum lag
for startSample = 1:OSR
    segment = s2(startSample:OSR:end);
    temp = xcorr(segment, s1, maximumLag); %cross correl.
    %strip the values corresponding to negative lags
    temp(1:(length(temp)-1)/2)=[]; 
    %first method implements a definition of cross-correl.
    %different than xcorr. Adjust the conjugate:
    temp = temp'; %' is complex conjugate and transpose
    endSample = startSample+OSR*(length(temp)-1);
    crossCorrelation2(startSample:OSR:endSample) = temp;
end
%Compare the methods via the maximum error (around 1e-10)
maxError = max(abs(crossCorrelation-crossCorrelation2))