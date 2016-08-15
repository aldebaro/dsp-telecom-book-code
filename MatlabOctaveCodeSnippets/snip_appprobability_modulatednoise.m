M=5000; %number of realizations for ensemble statistics
N=1000; %number of samples of each realization
P=30; %sinusoid period (in samples)
X=zeros(N,M); %pre-allocate space
Wc=2*pi/P; Phc=pi/5; %carrier frequency and phase, both in radians
n=0:N-1; carrier=transpose(cos(Wc*n+Phc)); %same for all realizations
%carrier(carrier>0)=1; carrier(carrier<0)=-1; %if wants square wave
for m=1:M %for each realization
    X(:,m)=randn(N,1).*carrier; %WGN modulated by sinusoidal carrier
end
