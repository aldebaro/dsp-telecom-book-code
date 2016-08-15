function figs_digicomm_regeneration
clear all; clf
rand('state',0); %reset the seed to reproduce sequences
RSRdB=3; %RSR = 3 dB
plotForGivenSNR(RSRdB,'regeneration_snr_plus3')
RSRdB=-3; %RSR = -3 dB
plotForGivenSNR(RSRdB,'regeneration_snr_minus3')

return %properly finish the main function (not a mistake here)

function plotForGivenSNR(RSRdB, outputFileName)
N=10;
n=0:N-1;

myaxis=[0 10 -2 2];

x=4*(rand(1,N)-0.5);
x=round(x);
signalPower = mean(x.^2);
RSRlinear= 10^(RSRdB/10);
noisePower = signalPower / RSRlinear;

%original
subplot(221); 
stem(n,x); grid
ylabel('Clean x_q[n]')
axis(myaxis)
set(gca,'Xtick',[]); set(gca,'Ytick',[-1.5 -0.5 0.5])

%noise
r=sqrt(noisePower) *(rand(1,N)-0.5);
subplot(222); 
stem(n,r); grid
ylabel('Noise n[n]')
axis(myaxis)
set(gca,'Xtick',[]); set(gca,'Ytick',[-1.5 -0.5 0.5])

%regenerated
subplot(223);
y=round(x+r);
y(find(y>2))=2; %force the maximum = 2
y(find(y<-2))=-2; %force the minimum = -2
stem(n,y); grid
ylabel('Regenerated y_q[n]')
xlabel('Sample (n)')
axis(myaxis)
set(gca,'Xtick',[]); set(gca,'Ytick',[-1.5 -0.5 0.5])

%Error
subplot(224); 
stem(n,y-x); grid
ylabel('Error: y_q[n]-x_q[n]')
xlabel('Sample (n)')
axis(myaxis)
set(gca,'Xtick',[]); set(gca,'Ytick',[-1.5 -0.5 0.5])

writeEPS(outputFileName,'font12Only');