snip_appprobability_modulatednoise %generate signal

subplot(211);
plot(0:N-1,X(:,1));
%xlabel('time n');
ylabel('x[n]');

subplot(212);
varianceOverTime = var(X,0,2);
plot(0:N-1,varianceOverTime);
xlabel('time n'); ylabel('Variance of x[n]');
writeEPS('modulatedNoiseStats','font12Only')

clf
maxTime=3*P; %P is the sinusoid period
[Rxx,n1,n2]=ak_correlationEnsemble(X, maxTime);

akmap=flipud(copper); %black is largest value
%akmap(1,:)=[1 1 1]; %include white color (did not work well!)
colormap(akmap);

%Rxx(abs(Rxx)<1e-1)=0; %did not become beautiful
%find (Rxx==max(abs(transpose(Rxx))))

%% Show in pair of absolute times
mesh(n1,n2,transpose(Rxx)); %use transpose of Rxx such that n1,n2
xlabel('time n1');ylabel('time n2');zlabel('R_X[n1,n2]'); %are row and column
colormap(akmap);
view([42.5 50]);
writeEPS('modulatedNoise1')

%% Show as absolute and relative times
[newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx,n1,n2);
mesh(n,lags,transpose(newRxx)); %use transpose of Rxx such that n1,n2
xlabel('time n');ylabel('lag l');zlabel('R_X[n,l]'); %are row and column
%colorbar
view([24.5 34]);
writeEPS('modulatedNoise2')

%% Cyclic correlation
[nlength,lagslength]=size(newRxx);
%control alpha resolution
if 0 
    fftLengthAlpha=2^nextpow2(4*nlength); %zero padding
else
    fftLengthAlpha=nlength; %do not zero pad to get numbers right
end
deltaAlphaNormalized=2/fftLengthAlpha;
alphas=(-1:deltaAlphaNormalized:1-deltaAlphaNormalized);
Cxx=(1/fftLengthAlpha)*fft(newRxx,fftLengthAlpha);
mesh(alphas,lags,transpose(abs(fftshift(Cxx,1)))); 
%mesh(transpose(abs(Sxx))); 
xlabel('cycle \alpha');ylabel('lag l');zlabel('|C_X[\alpha_k,l]|'); 
writeEPS('modulatedNoise3')

%% Cyclic spectrum
[alphalength,lagslength]=size(Cxx);
Sxx = (1/lagslength)*fft(Cxx,lagslength,2);
deltaFNormalized=2/lagslength;
f=(-1:deltaFNormalized:1-deltaFNormalized);
mesh(alphas,f,transpose(abs(fftshift(Sxx,1)))); 
xlabel('cycle \alpha');ylabel('frequency f');zlabel('|S_X[\alpha_k,f]|'); 
writeEPS('modulatedNoise4')