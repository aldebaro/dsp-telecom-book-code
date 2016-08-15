randn('state',0); rand('state',0); %reset both generators
numberOfSymbols=10; %number of symbols to be transmitted
M = 4; %modulation order (number of symbols)
noisePower=6; %noise power
oversampling=8; %oversampling factor L
p = ones(1,oversampling); %shaping pulse
Ep = sum(p.^2); %calculate the pulse energy
h_mf = fliplr(p); %matched filter (MF) impulse response
constellation=[-3 -1 1 3]; %4-PAM constellation, energy=5
symbolIndicesTx=floor(4*rand(1,numberOfSymbols));%indices
transmittedSymbols=constellation(symbolIndicesTx+1);%symb.
s = zeros(1,oversampling*numberOfSymbols); %pre-allocate
s(1:oversampling:end) = transmittedSymbols; %upsampled s
s = filter(p,1,s); %PAM signal
n = sqrt(noisePower)*randn(size(s)); %Gaussian noise
r = s + n; %add noise
rfiltered = filter(h_mf,1,r); %matched filtering operation
rfiltered = rfiltered/Ep; %normalize by pulse energy
initialSample = oversampling; %output after symbol period
receivedSymbols=rfiltered(oversampling:oversampling:end); 
symbolIndicesRx = pamdemod(receivedSymbols, M); %demodul.
SER=sum(symbolIndicesTx~=symbolIndicesRx)/numberOfSymbols
clf; stem(rfiltered); hold; stem(s,'rx') %plot signals
stem(r,'g+') %plot received signal
sampleInstants=[initialSample:oversampling: ...
    length(rfiltered)]; %indicate sampling instants
stem(sampleInstants,rfiltered(sampleInstants),'kd')

