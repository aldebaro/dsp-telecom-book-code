function figs_transforms_dft

%using orthonormal DFT
clf
N=32;
[Ah,A]=ak_fftmtx(N,2); %DTFS as in fft/N
n=0:N-1; k=n; %define k to make more clear when it is k and when it is n
x1=10*cos(2*pi*0/32*n); %first signal: DC
X1=Ah*transpose(x1);
subplot(521); stem(n,x1); ylabel('x_0[n]'); axis([0 31 0 11]);
subplot(522); stem(k,real(X1)); ylabel('Re\{ X_0[k] \}');axis([0 31 0 11])
x2=10*cos(2*pi/32*n); %second signal: slowest cosine
X2=Ah*transpose(x2);
subplot(523); stem(n,x2); ylabel('x_1[n]'); axis([0 31 -11 11]);
subplot(524); stem(k,real(X2)); ylabel('Re\{ X_1[k] \}');axis([0 31 0 10])
x3=10*cos(2*pi*2/32*n); %signal
X3=Ah*transpose(x3);
subplot(525); stem(n,x3); ylabel('x_2[n]'); axis([0 31 -11 11]);
subplot(526); stem(k,real(X3)); ylabel('Re\{ X_2[k] \}');axis([0 31 0 10])
x4=10*cos(2*pi*16/32*n); %signal
X4=Ah*transpose(x4);
subplot(527); stem(n,x4); ylabel('x_{16}[n]'); axis([0 31 -11 11]);
subplot(528); stem(k,real(X4)); ylabel('Re\{ X_{16}[k] \}');axis([0 31 0 10])
x5=10*cos(2*pi*31/32*n); %signal
X5=Ah*transpose(x5);
subplot(529); stem(n,x5); ylabel('x_{31}[n]'); xlabel('n'); axis([0 31 -11 11]);
subplot(5,2,10); stem(k,real(X5)); ylabel('Re\{ X_{31}[k] \}');
xlabel('k');axis([0 31 0 10])
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*1.2); %adjust the size making it "taller"
set(gcf, 'Position',x);
writeEPS('dftexamples','font12Only')

%another figure with reading in Volts
close all
if 0
    clf
    N=32;
    [Ah,A]=ak_fftmtx(N,2); %not orthonormal
    n=0:N-1; k=n; %define k to make more clear when it is k and when it is n    
    x1=10*cos(2*pi*0/32*n); %first signal: DC
    X1=Ah*transpose(x1);
    subplot(521); stem(k,real(X1)); ylabel('real\{ X_1[k] \}');axis([0 31 0 11])
    title('Angles from 0 to 2\pi');
    subplot(522); stem(k2,fftshift(real(X1))); axis([-16 15 0 11])
    title('Angles from -\pi to \pi');
    x2=10*cos(2*pi/32*n); %second signal: slowest cosine
    X2=Ah*transpose(x2);
    subplot(523); stem(k,real(X2)); ylabel('real\{ X_2[k] \}');axis([0 31 0 11])
    subplot(524); stem(k2,fftshift(real(X2)));  axis([-16 15 0 11])
    x3=10*cos(2*pi*2/32*n); %signal
    X3=Ah*transpose(x3);
    subplot(525); stem(k,real(X3)); ylabel('real\{ X_3[k] \}');axis([0 31 0 11])
    subplot(526); stem(k2,fftshift(real(X3)));  axis([-16 15 0 11])
    x4=10*cos(2*pi*16/32*n); %signal
    X4=Ah*transpose(x4);
    subplot(527); stem(k,real(X4)); ylabel('real\{ X_4[k] \}');axis([0 31 0 11])
    subplot(528); stem(k2,fftshift(real(X4))); axis([-16 15 0 11])
    x5=10*cos(2*pi*31/32*n); %signal
    X5=Ah*transpose(x5);
    subplot(529); stem(k,real(X5)); ylabel('real\{ X_5[k] \}');axis([0 31 0 11]), xlabel('k');
    subplot(5,2,10); stem(k2,fftshift(real(X5)));  axis([-16 15 0 11])
    xlabel('k');
    writeEPS('dftexamples2','font12Only')
end

%more complex example
clf
clear all
N=32; %number of DFT-points
n=0:N-1; %abscissa to generate signal below
x=2+3*cos(2*pi*6/32*n)+8*sin(2*pi*12/32*n)-...
    + 4*cos(2*pi*7/32*n)+ 6*sin(2*pi*7/32*n);
X=fft(x)/N; %calculate DTFS spectrum via DFT
X(abs(X)<1e-12)=0; %mask numerical errors
k2=-N/2:N/2-1;
subplot(511); stem(n,x); ylabel('x[n]'); xlabel('n'), axis tight
subplot(512); stem(k2,fftshift(real(X))); ylabel('Re\{ X[k] \}'); axis tight
subplot(513); stem(k2,fftshift(imag(X))); ylabel('Im\{ X[k] \}'); axis tight
subplot(514); stem(k2,fftshift(abs(X))); ylabel('Mag\{ X[k] \}'); axis tight
%subplot(515); stem(k2,fftshift(unwrap(angle(X)))); ylabel('Ph\{ X[k] \}'); axis tight
subplot(515); stem(k2,fftshift(angle(X))); ylabel('Ph\{ X[k] \}'); axis tight
xlabel('k')
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*1.5); %adjust the size making it "taller"
set(gcf, 'Position',x);
writeEPS('dftexamples3','font12Only')

%non-periodic signal example
close all
clf
N=16;
n=0:N-1;
k2=-N/2:N/2-1;
x7=4*cos(2*pi/6*n); %signal
X7=fft(x7)/N;
subplot(311); stem(n,x7); ylabel('x[n]'); xlabel('n')
subplot(312); stem(k2,fftshift(abs(X7))); ylabel('Mag\{ X[k] \}');
subplot(313); stem(k2,fftshift(unwrap(angle(X7)))); ylabel('Ph\{ X[k] \} (rad)');
xlabel('k')
writeEPS('dftexamples4','font12Only')

%leakage
clf
stem(n,x7); hold on
stem(n+N,x7,'rx');
ak_add3dots
xlabel('n'); ylabel('x[n]')
writeEPS('leakage','font12Only')

%DFT cost
clf
N=2:200:2^13;
dftCost = N.^2;
fftCost = N.*log2(N);
%plot(N,dftCost,N,fftCost);
semilogy(N,dftCost,'x-',N,fftCost,'o-');
legend1 = legend('DFT matrix mult.: O(N^2)','FFT cost: O(N log_2 N)');
xlabel('Number (N) of points');
ylabel('Estimate of computational cost (log scale)');
set(legend1,'Position',[0.1733 0.7486 0.4415 0.1354]);
%axis tight
axis([0 8192 1 1e8])
grid
writeEPS('dftfftcost');

if 0 %I am disabling function calls below because rsmak is in
    %Matlab's splines toolbox and not in Octave. Will not use it

    showUnityCircle(3)
    writeEPS('circledivided3');

    showUnityCircle(4)
    writeEPS('circledivided4');

    showUnityCircle(5)
    writeEPS('circledivided5');

    showUnityCircle(6)
    writeEPS('circledivided6');
end

end

function showUnityCircle(N)
clf
if 0
    %two instructions below are equivalent
    %but could not use, because arrows would be wrongly positioned
    %set(gca,'DataAspectRatio',[1 1 1])%relative magnitudes along each axis
    axis square
else
    Position = [360 181 560 517]; %resize the whole figure
end
set(gcf,'Position',Position);
circle = rsmak('circle'); %circle
fnplt(circle)
k=0:N-1;
W_N = (exp(-2*pi*j/N)).^k;
for i=1:N
    ak_drawvector(W_N(i));
    text(real(W_N(i))+0.1,imag(W_N(i))-0.1,...
        ['k=' num2str(k(i))],'FontSize',12,'FontWeight','bold')
end

end