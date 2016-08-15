M=16; %modulation order, number of distinct symbols
N = 400000; % number of symbols
L=8; %oversampling factor
indices=floor(M*rand(1,N))+1; %random indices from [1, M]
alphabet=[-(M-1):2:M-1]; %symbols ...,-3,-1,1,3,5,7,...
Ec=mean(alphabet.^2); %constellation average energy
symbols=alphabet(indices); %obtain M random symbols
m_upsampled=zeros(1,N*L); %pre-allocate space with zeros
m_upsampled(1:L:end)=symbols; %insert symbols, L-1 zeros in-between
p=ones(1,L); %shaping pulse is a NRZ square waveform
s=conv(m_upsampled,p); %convolve symbols with shaping pulse
Fs = 2*pi; %normalized sampling frequency
[SpamEstimated,f]=ak_psd(s,Fs); %find PSD in dBm/Hz
Tsym=L/Fs; %the normalized symbol interval
SpamTheoretical=Ec*Tsym*sinc(f*Tsym).^2; % theoretical expression
clf; plot(f,SpamEstimated-30,f,10*log10(SpamTheoretical),'.-r');
xlabel('\Omega (rad)'); ylabel('PSD (dBW / normalized freq.)');
legend('Estimated','Theoretical'), axis([-pi pi -20 30]), grid
