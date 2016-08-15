function figs_digicomm_isi2
clf
symbols=[3 -1 3 1]; %symbols used for all plots

%First pulse
N0 = 1; %sample to start obtaining the symbols
p=[1 1 1 1]; %shaping pulse
L=4; %oversampling factor
ak_plotNyquistPulse(p,L) %graphs in frequency domain
writeEPS('pulse1_spectrum');
[isi,signalParcels] = ak_calculateISI(symbols, p, L, N0);
myplot(isi, signalParcels,symbols,L,p,N0)
writeEPS('pulse1_timedomain');

%Second pulse
N0 = 4; %sample to start obtaining the symbols
p=[0 -1 2 1 1 -2 0];
L=3; %oversampling factor
ak_plotNyquistPulse(p,L)
writeEPS('pulse2_spectrum');
[isi,signalParcels] = ak_calculateISI(symbols, p, L, N0);
myplot(isi, signalParcels,symbols,L,p,N0)
writeEPS('pulse2_timedomain');

%Third pulse
L=3; %oversampling factor
r=0.5; %roll-off factor
p=ak_rcosine(1,L,[],r,2);
N0=1+(length(p)-1)/2;%sample to start obtaining symbols
ak_plotNyquistPulse(p,L) %graphs in frequency domain
writeEPS('pulse3_spectrum');
[isi,signalParcels] = ak_calculateISI(symbols, p, L, N0);
myplot(isi, signalParcels,symbols,L,p,N0)
writeEPS('pulse3_timedomain');

%Compare different filter orders
clf
L=3; %oversampling factor
r=1; %roll-off factor
p1=ak_rcosine(1,L,[],r,1);
p2=ak_rcosine(1,L,[],r,5);
p3=ak_rcosine(1,L,[],r,20);
[H1,w]=freqz(p1,1);
[H2,w]=freqz(p2,1);
[H3,w]=freqz(p3,1);
plot(w,20*log10(abs(H1)),w,20*log10(abs(H2)),w,20*log10(abs(H3)))
legend(['Order ' num2str(length(p1)-1)], ...
    ['Order ' num2str(length(p2)-1)], ...
    ['Order ' num2str(length(p3)-1)])
xlabel('\Omega (rad)')
ylabel('|P(e^{j \Omega})|')
grid
writeEPS('compareRaisedCosines');

end

function myplot(isi,signalParcels,symbols,oversample,p,N0)
clf
[nr, nc]=size(signalParcels); %nc is the number of samples of each parcel
subplot(311);
extendedPulse=zeros(1,nc);
extendedPulse(1:length(p))=p;
stem(0:length(extendedPulse)-1,extendedPulse);
title('Shaping pulse')
%axis tight
subplot(312);
hold on
myColors = get(gca,'ColorOrder');

for k=1:nr
    myColor = myColors(mod(k+1,7)+1,:);
    plot(0:nc-1,signalParcels(k,:),'Color',myColor,'Marker','x');
end
title('Shifted and scaled versions of the pulse')
grid
%axis tight
subplot(313);
stem(0:length(sum(signalParcels))-1,sum(signalParcels)); 
hold on
numSymbols = length(symbols); %number of symbols
plot((N0:oversample:N0+numSymbols*oversample-1)-1,symbols,'xr','markersize',14);
title('Transmitted signal')
%axis tight
grid
ISIenergy = sum(isi.^2)
end