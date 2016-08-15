% The goal here is to show that the modulation index h can not be
% easily defined as h=max(m(t))/A if m(t) is not "symmetric". Hence,
% two examples of AM modulating signals m(t) are used: a) the
% traditional m(t) as a single cosine and b) the "non-symmetric"
% waveform. Choose between the two examples using:
example = 2; %1 corresponds to a) indicated above, and b) otherwise
%% 1- Generate modulating signal m(t)
if example == 1 %m(t) as single sinusoid
    Nm=40;
    m=4*cos(2*pi/300*(0:20*Nm-1));
else %m(t) with three amplitudes and non-zero mean    
    N=80; %number of samples with the same amplitude value
    Vamp1=10; Vamp2=-2; Vamp3=-Vamp2; %three amplitude values
    x=[Vamp1*ones(1,N) Vamp2*ones(1,N) Vamp3*ones(1,N)]; %single period
    m=[x x]; %m=[x x x x]; %repeat the signal for visualization purpose
end
%% 2- Generate carrier
carrier = Acarrier*cos(2*pi/Ncarrier*(0:length(m)-1));
M=length(m); Ncarrier=20; Acarrier=1;
%% 3- Generate AM signal
A = -min(m); %would lead to h=100% if h=max(m)/A were valid
amtx = (m+A).*carrier; %AM transmit signal
%% 4- Implement part of AM demodulation, but without filtering
amrx = abs(amtx) - A;
%% 5- Generate plots
subplot(211); plot(amrx); hold on, plot(m,'r')
legend('|AM signal|-A','m(t)'); axis tight
subplot(212); plot(amtx,'-x'); hold on; plot(A*carrier,'r')
legend('AM signal','A*cos'), axis tight
%% 6- Definitions of h found in literature
h1=max(m)/A; %simple definition of modulation index h
h2=(max(m+A)-min(m+A))/(max(m+A)+min(m+A)); %another definition of h
disp(['Modulation index according to definitions: ' ...
    num2str(h1) ' and ' num2str(h2)])