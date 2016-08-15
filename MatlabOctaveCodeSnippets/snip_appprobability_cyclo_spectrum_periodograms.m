P=30; %sinusoid period (in samples)
N=1e3*P; %number of samples of this realization (force multiple of P)
Wc=2*pi/P; Phc=pi/5; %carrier frequency and phase, both in radians
n=0:N-1; carrier=transpose(cos(Wc*n+Phc)); %same for all realizations
x=randn(N,1).*carrier; %WGN modulated by sinusoidal carrier
L = length(x);		% signal length
Nw = 128;			% window length
Nv = fix(2/3*Nw);	% block overlap
nfft = 2*Nw;		% FFT length
da = 1/L;           % cyclic frequency resolution (normalized freq)
cycleIndex = round(2*Wc/(2*pi*da)); %find the correct cycle
a1 = cycleIndex-20; % first cyclic freq. bin to scan (cycle a1*da)
a2 = cycleIndex+20; % last cyclic freq. bin to scan (cycle a2*da)
S = zeros(nfft,a2-a1+1); %pre-allocate space
for k = a1:a2; % Loop over all chose cyclic frequencies
    spectralObject = cps_w(x,x,k/L,nfft,Nv,Nw,'sym'); %cycle k/L
    S(:,k-a1+1) = spectralObject.S; %extract S(alpha,f) from object
end
alphas = 2*pi*da*(a1:a2); %get all cycles in rad
sumMagOverFreq=sum(abs(S)); %for each cycle, sum all magnitudes
indMax=find(sumMagOverFreq == max(sumMagOverFreq),1);
WEstimated=alphas(indMax)/2; %estimated frequency from cycle of peak
periodEstimated=round(2*pi/WEstimated); %period in samples
phaseEstimated=mean(angle(S(:,indMax)))/2;%half averaged peak's phase
phaseOffset=wrapToPi(Phc) - wrapToPi(phaseEstimated); %force [-pi,pi]
disp(['Period:  Correct=' num2str(P) ', Estimated=' ...
    num2str(periodEstimated) ' (samples)'])
disp(['Cycle:  Correct=' num2str(Wc) ', Estimated=' ...
    num2str(WEstimated) '(rad). Error=' num2str(Wc-WEstimated)])
disp(['Phase:  Correct=' num2str(Phc) ', Estimated=' ...
    num2str(phaseEstimated) '(rad). Error=' num2str(phaseOffset)])
%% Plots graphs
Wfrequencies = pi*spectralObject.f; %get all frequencies in rad
subplot(211), mesh(alphas,Wfrequencies,abs(S)); %plot magnitude
xlabel('cycle \alpha'); ylabel('\Omega');zlabel('|S(\alpha,\Omega)|')
phaseOfPeakCycle=zeros(size(S));
phaseOfPeakCycle(:,indMax)=angle(S(:,indMax));
subplot(212), mesh(alphas,Wfrequencies,phaseOfPeakCycle); %plot phase
xlabel('cycle \alpha'); ylabel('\Omega'); zlabel('Phase (rad)')

if 0 %in case want to investigate how the phase varies
    for i=1:length(alphas)
        phaseEstimated=mean(angle(S(:,i)))/2; %phase is half 
        phaseOffset=wrapToPi(Phc) - wrapToPi(phaseEstimated);
        phaseOfPeakCycle=zeros(size(S));
        phaseOfPeakCycle(:,i)=angle(S(:,indMax));
        mesh(alphas,Wfrequencies,phaseOfPeakCycle); %plot phase
        xlabel('cycle \alpha'); ylabel('\Omega'); 
        zlabel('Phase (rad)')
        disp(['Phase:  Correct=' num2str(Phc) ', Estimated=' ...
            num2str(phaseEstimated) '(rad). Error=' ...
            num2str(phaseOffset)])
        pause
    end
end