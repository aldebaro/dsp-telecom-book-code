function figs_digicomm_eyediagram
    
%Generation of an eye-diagram.
clear all, close all
rand('twister', 5489); %allow replicating results
randn('seed', 100); %allow replicating results
%4-PAM sequence, Alphabet {-3 –1 1 3}, 100 symbols
N = 100; %number of symbols 
a = [-3 -1 1 3]; % Symbol alphabet
ind = floor(4*rand(N,1));  %Integers between 0 and 3
ind = ind+1; % Now, the vector includes random integers between 1 and 4
pam = a(ind); % Generate 4-PAM symbol sequence
Fs = 24000; % Sampling frequency (Hz)
Tsym = 1/8000; % Symbol time interval (sec)
L = Fs*Tsym; % Oversampling factor
t = -5*Tsym:1/Fs:5*Tsym; % Sampling intervals

%Case 1: pulse
p = ones(1,L);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams); % Pulse shaping filtering
%Plots:
subplot(411);
P=30;
stem(0:P-1,pam(1:P)); % Plots the symbol stream
title('PAM symbols'); 
subplot(412)
stem(0:3*P-1,pams(1:3*P)); title('PAM with zeros'); axis tight
subplot(413)
stem([p zeros(1,10)]); ylabel('Amplitude'); %plot(t,p);hold;xlabel('Tsymime [s]');
title('Square pulse');
subplot(414)
stem(0:3*P-1,xn(1:3*P)); title('filtered PAM'); axis tight
writeEPS('pulseForEyeDiagram','font12Only');
%Plotting the Eye-Diagram
firstSample = 2; %firstSample = (length(p) + 1)/2;
increment = 2 * L;
clf
ak_plotEyeDiagram(firstSample,increment,xn)
writeEPS('eyeDiagramPulse','font12Only');

%Case 2: raised cosine r=1
r = 1; % Roll-off factor
p=getRaisedCosine(r,Fs,Tsym,N,t);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams); % Pulse shaping filtering
%Plots:
subplot(411);
P=30;
stem(0:P-1,pam(1:P)); % Plots the symbol stream
title('PAM symbols'); 
subplot(412)
stem(0:3*P-1,pams(1:3*P)); title('PAM with zeros'); axis tight
subplot(413)
stem(p); ylabel('Amplitude'); %plot(t,p);hold;xlabel('Tsymime [s]');
title('Raised cosine pulse r=1');
subplot(414)
stem(0:3*P-1,xn(1:3*P)); title('filtered PAM'); axis tight
writeEPS('rcosineForEyeDiagramr1','font12Only');
%Plotting the Eye-Diagram
firstSample = 5*L+2; %firstSample = (length(p) + 1)/2;
increment = 2 * L;
clf
ak_plotEyeDiagram(firstSample,increment,xn)
writeEPS('eyeDiagramRcosiner1','font12Only');

%Case 3: raised cosine r=0
r = 0; % Roll-off factor
p=getRaisedCosine(r,Fs,Tsym,N,t);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams); % Pulse shaping filtering
%Plots:
subplot(411);
P=30;
stem(0:P-1,pam(1:P)); % Plots the symbol stream
title('PAM symbols'); 
subplot(412)
stem(0:3*P-1,pams(1:3*P)); title('PAM with zeros'); axis tight
subplot(413)
stem(p); ylabel('Amplitude'); %plot(t,p);hold;xlabel('Tsymime [s]');
title('Raised cosine pulse r=0');
subplot(414)
stem(0:3*P-1,xn(1:3*P)); title('filtered PAM'); axis tight
writeEPS('rcosineForEyeDiagramr0','font12Only');
%Plotting the Eye-Diagram
firstSample = 5*L+2; %firstSample = (length(p) + 1)/2;
increment = 2 * L;
clf
ak_plotEyeDiagram(firstSample,increment,xn)
writeEPS('eyeDiagramRcosiner0','font12Only');

%binary comm with AWGN
N=1000;
a = [-1 1]; % Symbol alphabet
ind = floor(2*rand(N,1));  %Integers between 0 and 1
ind = ind+1; % Now, the vector includes random integers 1 or 2
pam = a(ind); % Generate 4-PAM symbol sequence
Fs = 24000; % Sampling frequency (Hz)
Tsym = 1/8000; % Symbol time interval (sec)
L = Fs*Tsym; % Oversampling factor
t = -5*Tsym:1/Fs:5*Tsym; % Sampling intervals
firstSample = 5*L+2; %firstSample = (length(p) + 1)/2;
increment = 2 * L;
myaxis=[0 5 -2 2];
clf
%a) r=0 and no AWGN
r = 0; % Roll-off factor
p = ak_rcosine(1,L,'fir/normal',r,5);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams); % Pulse shaping filtering
subplot(221);
ak_plotEyeDiagram(firstSample,increment,xn)
axis(myaxis);
title('r=0 and noise-free');
%b) r=1 and no AWGN
r = 1; % Roll-off factor
p = ak_rcosine(1,L,'fir/normal',r,5);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams); % Pulse shaping filtering
subplot(223);
ak_plotEyeDiagram(firstSample,increment,xn)
axis(myaxis)
title('r=1 and noise-free');
%Set SNR
SNRdB=15;
SNR=10^(0.1*SNRdB);
Ps=mean(xn.^2);
Pr=Ps/SNR;
noise = sqrt(Pr)*randn(size(xn));
EstimatedSNRdB = 10*log10(mean(xn.^2)/mean(noise.^2));
%c) r=0 and AWGN
r = 0; % Roll-off factor
p = ak_rcosine(1,L,'fir/normal',r,5);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams) + noise; % Pulse shaping filtering and AWGN
subplot(222);
ak_plotEyeDiagram(firstSample,increment,xn)
axis(myaxis);
title('r=0 and SNR=15 dB (AWGN)');
%d) r=1 and AWGN
r = 1; % Roll-off factor
p = ak_rcosine(1,L,'fir/normal',r,5);
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; % Pulse sequence {a1 0 0 a2 0 0 a3 0 0 a4 0 ...}
xn = filter(p,1,pams) + noise; % Pulse shaping filtering and AWGN
subplot(224);
ak_plotEyeDiagram(firstSample,increment,xn)
axis(myaxis)
title('r=1 and SNR=15 dB (AWGN)');
writeEPS('eyeDiagramAWGN','font12Only');
end

function p=getRaisedCosine(r,Fs,Tsym,N,t)
    %N = length(pam); % Number of symbols
    t = t+0.00000001; % Otherwise, the denominator would be zero at t=0
    % Raised-Cosine FIR filter:
    p = (sin(pi*t/Tsym)./(pi*t/Tsym)) .* ...
        (cos(r*pi*t/Tsym)./(1-(2*r*t/Tsym).^2)); 
end