function ak_showQfactors
N=6; %order of filter
Wc=100; %cutoff frequency
disp('- Butterworth filter:');
[z,p,k]=butter(N,Wc,'s'); %design Butterworth
calculateQfactors(p) %calculate and display Q-factors
disp('- Chebyshev 1 filter:');
Rp=1; %maximum ripple at passband
[z,p,k]=cheby1(N,Rp,Wc,'s'); %design Chebyshev type 1
calculateQfactors(p) %calculate and display Q-factors
disp('- Elliptic filter:');
Rs=30; %minimum attenuation at stopband
Wp=Wc; %elliptic natural frequency equals cutoff frequency
[z,p,k]=ellip(N,Rp,Rs,Wp,'s'); %design Elliptic filter
calculateQfactors(p) %calculate and display Q-factors
end % end function ak_showQfactors
function calculateQfactors(p) %p has the poles
p=p(find(imag(p)>0)); %exclude real poles and complex conjugates
N=length(p); %number of complex poles with non-zero imaginary parts
for i=1:2:N
    pole = p(i);
    Q = abs(pole) / (2*(-real(pole)));
    disp(['Poles=' num2str(real(pole)) ' +/- j' ...
        num2str(imag(pole)) ' => Q=' num2str(Q)]);
end %end for
end %end function calculateQfactors