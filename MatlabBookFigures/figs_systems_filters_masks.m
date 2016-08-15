close all
Wp=2*pi*100;
Ws=2*pi*400;
Ap=1; %maximum allowable passband attenuation in dB
As=20 %minimum allowable stopband attenuation in dB
[filterOrder,Wcutoff] = buttord(Wp,Ws,Ap,As,'s')

[B,A]=butter(filterOrder,Wcutoff,'s');

%make sure frequencies of interest are included in w grid:
fmax=500; %maximum frequency of w (in Hz)
w=sort([Wp Ws Wcutoff linspace(0,2*pi*fmax,200)]);
ndxWp = find(w==Wp); %need for makedatatip
ndxWs = find(w==Ws);
ndxWc = find(w==Wcutoff);

[H,w]=freqs(B,A,w);

subplot(211);
hLinearPlot = plot(w/(2*pi),abs(H));
ylabel('|H(f)| (linear)');
makedatatip(hLinearPlot,[ndxWp ndxWc ndxWs])
subplot(212);
hdBplot = plot(w/(2*pi),20*log10(abs(H)))
ylabel('|H(f)| (dB)');
xlabel('frequency (Hz)');
makedatatip(hdBplot,[ndxWp ndxWc ndxWs])

writeEPS('freqs_of_interest');


%plot frequency response, show H(f) for one pole in s=-2
B=1;
A=[1 2];
fmax=3; %maximum frequency of w (in Hz)
w=sort([-4 4 linspace(-2*pi*fmax,2*pi*fmax,200)]);
ndxW1 = find(w==-4);
ndxW2 = find(w==4);
[H,w]=freqs(B,A,w);
subplot(211);
hmagPlot = plot(w,abs(H));
ylabel('|H(f)| (linear)');
makedatatip(hmagPlot,[ndxW1 ndxW2])
subplot(212);
hphasePlot = plot(w,angle(H))
ylabel('Phase of H(f) (rad)');
xlabel('frequency (rad/s)');
makedatatip(hphasePlot,[ndxW1 ndxW2])
writeEPS('freq_response_onepole');

clf
%plot frequency response, show H(f) for one pole in s=-2
B=1;
A=[1 -0.7]; 
fmax=15/2/pi; %maximum frequency of w divided by 2*pi
w=sort([-pi/2 pi/2 linspace(-2*pi*fmax,2*pi*fmax,200)]);
ndxW1 = find(w==-pi/2);
ndxW2 = find(w==pi/2);
[H,w]=freqz(B,A,w);
subplot(211);
hmagPlot = plot(w,abs(H));
ylabel('|H(e^{j \Omega})| (linear)');
%makedatatip(hmagPlot,[ndxW1 ndxW2])
makedatatip(hmagPlot,[ndxW2])
grid
ak_add3dots
subplot(212);
hphasePlot = plot(w,angle(H))
ylabel('Phase of H(e^{j \Omega}) (rad)');
xlabel('Angular frequency (rad)');
makedatatip(hphasePlot,[ndxW1 ndxW2])
grid
ak_add3dots
writeEPS('freq_response_onepole_discrete');

clf
freqz(B,A);
writeEPS('freqz_onepole_discrete');

clf
%plots the contribution of each pole to H(f)
N=6;
Wc=100;
fmax=2*Wc;
w=linspace(-fmax,fmax,200);
myaxis = [-200 100 -120 120]
[z,p,k]=butter(N,Wc,'s');
somePoles=p(1:2);
subplot(321); zplane([],somePoles); axis(myaxis); xlabel('')
ylabel('j\omega'), title('Used poles')
subplot(322); [H,w]=freqs(1,poly(somePoles),w); plot(w,abs(H));
ylabel('|H(\omega)|')
somePoles=p(1:4);
subplot(323); zplane([],somePoles); axis(myaxis); xlabel('')
ylabel('j\omega')
subplot(324); [H,w]=freqs(1,poly(somePoles),w); plot(w,abs(H));
ylabel('|H(\omega)|')
somePoles=p(1:6);
subplot(325); zplane(z,somePoles); axis(myaxis)
ylabel('j\omega'), xlabel('\sigma')
subplot(326); [H,w]=freqs(k*poly(z),poly(somePoles),w); plot(w,abs(H));
ylabel('|H(\omega)|')
xlabel('\omega (rad/s)')
writeEPS('freq_response_butter6ord');

clf
%also plots the contribution of each pole to H(f)
N=6;
Rp=1;
[z,p,k]=cheby1(N,Rp,Wc,'s');
somePoles=p(1:2);
subplot(321); zplane([],somePoles); axis(myaxis); xlabel('')
ylabel('j\omega'), title('Used poles')
subplot(322); [H,w]=freqs(1,poly(somePoles),w); plot(w,abs(H));
somePoles=p(1:4);
ylabel('|H(\omega)|')
subplot(323); zplane([],somePoles); axis(myaxis); xlabel('')
ylabel('j\omega')
subplot(324); [H,w]=freqs(1,poly(somePoles),w); plot(w,abs(H));
ylabel('|H(\omega)|')
somePoles=p(1:6);
subplot(325); zplane(z,somePoles); axis(myaxis)
ylabel('j\omega'), xlabel('\sigma')
subplot(326); [H,w]=freqs(k*poly(z),poly(somePoles),w); plot(w,abs(H));
xlabel('\omega (rad/s)')
ylabel('|H(\omega)|')
writeEPS('freq_response_cheby16ord');

close all
figure1=figure(1)
N=6;
Rp=1;
Rs=30;
Wp=Wc;
Wc=150;
fmax=2*Wc;
w=linspace(-fmax,fmax,200);
[z,p,k]=ellip(N,Rp,Rs,Wp,'s');
subplot(211); 
%zplane(z,p); %axis([-200 100 -200 200])
plot(real(z),imag(z),'o','MarkerSize',10)
hold on
plot(real(p),imag(p),'x','MarkerSize',10)
xlabel('Real Part')
ylabel('Imaginary Part')
axis([-50 20 -300 300])
grid
subplot(212); [H,w]=freqs(k*poly(z),poly(p),w); plot(w,20*log10(abs(H)));
xlabel('frequency (rad/s)')
ylabel('20 log_{10} |H(\omega)| (dB)')
axis([-300 300 -50 10])
% Create textarrow
annotation(figure1,'textarrow',[0.7083 0.6548],[0.3323 0.2282],...
    'TextEdgeColor','none',...
    'String',{'First zero'});

writeEPS('freq_response_ellip6ord');