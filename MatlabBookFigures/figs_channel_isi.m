function figs_channel_isi
clear all
close all
symbols=[3 -3 -3 3 1 -1]; %PAM symbols
L=100; %oversampling factor, an even number, large to mimic continuous-time
delay = 7; %group delay in symbols (# of samples is delay*L)
N0 = delay*L+1; %cursor: sample to start obtaining the symbols
%% First case: pulse
p=[zeros(1,N0-L/4) ones(1,L/2) zeros(1,L/2)]; %shaping pulse
mybestPlot(p,L,symbols,N0,'isiexample1','isiexample1zoom')
%% Second case: normal raised cosine
r = 0; % Roll-off factor
p = ak_rcosine(1,L,'fir/normal',r,delay); %normal raised cosine (RC)
mybestPlot(p,L,symbols,N0,'isiexample2','isiexample2zoom')
%% Third case: square root raised cosine
r = 0.7; % Roll-off factor
p = ak_rcosine(1,L,'fir/sqrt',r,delay); %square-root RC
p(p>0) = p(p>0).^0.4; %distort to increase ISI
p(p<0) = -(abs(p(p<0)).^0.4);
p = p/max(p); %make maximum value (corresponding to "cursor") to be 1
mybestPlot(p,L,symbols,N0,'isiexample3','isiexample3zoom')
end

%% Function to plot
function mybestPlot(p,L,symbols,N0,epsName1,epsName2)
numSymbols=length(symbols);
[isi,signalParcels] = ak_calculateISI(symbols, p, L, N0);
%myplot(isi, signalParcels,symbols,L,p,N0)
%function myplot(isi,signalParcels,symbols,oversample,p,N0)
symbolsPosition=(N0:L:N0+numSymbols*L-1)-1;
clf
[nr, nc]=size(signalParcels); %nc is the number of samples of each parcel
subplot(311);
extendedPulse=zeros(1,nc);
extendedPulse(1:length(p))=p;
plot(0:length(sum(signalParcels))-1,zeros(size(sum(signalParcels))));
hold on
ak_impulseplot(ones(size(symbolsPosition)),symbolsPosition,[]);
plot(0:length(extendedPulse)-1,extendedPulse,'r');
myaxis=axis; axis([600 1300 myaxis(3) myaxis(4)])
title('Pulse p(t) and sampling instants')
xlabel('')
%axis tight
subplot(312);
hold on
myColors = get(gca,'ColorOrder');

for k=1:nr
    myColor = myColors(mod(k+1,7)+1,:);
    %plot(0:nc-1,signalParcels(k,:),'Color',myColor,'Marker','x');
    plot(0:nc-1,signalParcels(k,:),'Color',myColor);
end
title(['p(t) shifted and scaled by the symbols [' num2str(symbols) '] (impulses)'])
hold on
ak_impulseplot(symbols,symbolsPosition,[]);
%grid
%axis tight
myaxis=axis; axis([600 1300 myaxis(3) myaxis(4)])
xlabel('')
subplot(313);
plot(0:length(sum(signalParcels))-1,sum(signalParcels));
hold on
numSymbols = length(symbols); %number of symbols

plot(symbolsPosition,symbols,'xr','markersize',14);
set(gca,'Ytick',[min(symbols):2:max(symbols)])
title('Signal y(t) at receiver and sampling instants')
myaxis=axis; axis([600 1300 myaxis(3) myaxis(4)])
%axis tight
grid
ISIpower = mean(isi.^2)
xlabel('Time (s)'), ylabel('Amplitude')
writeEPS(epsName1,'font12Only');

%another figure
clf
hold on
myColors = get(gca,'ColorOrder');

for k=1:nr
    myColor = myColors(mod(k+1,7)+1,:);
    %plot(0:nc-1,signalParcels(k,:),'Color',myColor,'Marker','x');
    plot(0:nc-1,signalParcels(k,:),'Color',myColor);
end
title(['p(t) shifted and scaled by the symbols [' num2str(symbols) '] (impulses)'])
hold on
ak_impulseplot(symbols,symbolsPosition,[]);
%grid
%axis tight
myaxis=axis; axis([600 1300 myaxis(3) myaxis(4)])
xlabel('')
xlabel('Time (s)'), ylabel('Amplitude')
writeEPS(epsName2,'font12Only');
end
