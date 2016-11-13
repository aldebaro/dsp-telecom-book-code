close all
chebyshevFilterType=1; %1 has ripple in passband, 2 in stopband
filterOrder=4; %H(s) filter order
zTosMapping='s=z*Fs'; %some transformation
%zTosMapping='s=(2*Fs*(z-1))./(z+1)'; %bilinear transformation
if chebyshevFilterType==1
    wfilter=8; %passband frequency (rad/s);
    passbandRipple=1; %maximum ripple in passband (dB)
    [Bs,As]=cheby1(filterOrder,passbandRipple,wfilter,'s'); %H(s)
elseif chebyshevFilterType==2
    wfilter=15; %stopband frequency (rad/s);
    stopbandRipple=40; %ripple down from the peak passband value (dB)
    [Bs,As]=cheby2(filterOrder,stopbandRipple,wfilter,'s'); % H(s)
end
Fs=(20*wfilter)/(2*pi); %choose sampling frequency (Hz)
%% Plot H(s) and the corresponding H(z)
slim=20;
[Xs,Ys]=meshgrid(linspace(-slim,slim,100)); %100x100 grid in S plane
s=Xs+1j*Ys; %matrix with all points of interest in s plane
Hs=polyval(Bs,s)./polyval(As,s); %H(s)
zlim=10;
[Xz,Yz]=meshgrid(linspace(-zlim,zlim,100)/Fs); %100x100 grid in Z plane
z=Xz+1j*Yz; %matrix with all points of interest in z plane
%for each point z at Z plane, find s and the corresponding value H(s)
%s=(2*Fs*(z-1))./(z+1); %use bilinear transformation
eval(zTosMapping); %for each z, find the corresponding s
%Use H(z)=H(s)|s=2Fs(z-1)/(z+1)
Hz=polyval(Bs,s)./polyval(As,s); %H(z)
figure(1)
meshc(Xs,Ys,20*log10(abs(Hs))); %plot in dB
xlabel('Re\{s\} (\sigma)'); ylabel('Im\{s\} (j\omega)');
zlabel('20 log_{10} |H(s)|');
figure(2)
meshc(Xz,Yz,20*log10(abs(Hz))); %plot in dB
xlabel('Re\{z\}'); ylabel('Im\{z\}');
zlabel('20 log_{10} |H(z)|');

%% The frequency responses
figure(3)
s=1j*linspace(-slim,slim,100); %w varies from -slim,slim
Hs_w=polyval(Bs,s)./polyval(As,s); %H(s) is in fact H(jw) here
subplot(311)
plot(imag(s),20*log10(abs(Hs_w)))
xlabel('\omega (rad/s)'), ylabel('20 log_{10} |H(j\omega)|');
axis tight
%find the mapping from s to Z over the imaginary axis of Z
z=1j*linspace(-pi,pi,100); %w varies from -slim,slim
eval(zTosMapping); %for each z, find the corresponding s
Hz_new_w=polyval(Bs,s)./polyval(As,s); %H(z) over Imaginary{Z}
subplot(312)
plot(imag(z),20*log10(abs(Hz_new_w)))
xlabel('Im\{z\}'), ylabel('20 log_{10} |H(Im\{z\})|');
axis tight
%find the mapping from s to Z over the unit circle
z=exp(1j*linspace(-pi,pi,100)); %w varies from -pi,pi
%s=(2*Fs*(z-1))./(z+1); %use bilinear transformation
eval(zTosMapping);
Hz_W=polyval(Bs,s)./polyval(As,s); %H(z) over the unit circle
subplot(313)
plot(angle(z),20*log10(abs(Hz_W)))
xlabel('\Omega (rad)'), ylabel('20 log_{10} |H(e^{j\Omega})|');
axis tight