M=4; %PAM order
constellation = -(M-1):2:M-1; %PAM constellation
N=10000000; %number of PAM symbols
m=constellation(floor(rand(1,N)*M)+1); %random PAM symbols
Ec=mean(m.^2); %average constellation energy
L=4; %oversampling factor 
p=[1:8]; %arbitrary shaping pulse with duration longer than L
mu=zeros(1,L*N); mu(1:L:end)=m; %upsampled signal
s=filter(p,1,mu); %generate PAM signal
Ep=sum(p.^2); Pu=mean(mu.^2); Ps=mean(s.^2); 
disp(['Ec=' num2str(Ec) ' and Pu=Ec/L=' num2str(Pu)])
disp(['Pu*Ep=' num2str(Pu*Ep) ' should be equal to Py=' num2str(Ps)])

