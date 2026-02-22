%Calculate the unscaled autocorrelation R(lag) of x
x=[1+1j 2 3 4]; %define some vector x to test the code
N=length(x); %number of non-zero signal values
%% Option 1) x(n+lag)*conj(x(n))
R=zeros(1,N); %space for lag=0,1,...N-1
R(1)=sum(abs(x).^2); %R(0) is the energy
for lag=1:N-1 %for each positive lag
    temp = 0; %partial value of R
    for n=1:N-lag %vary n over valid products
        temp = temp + x(n+lag)*conj(x(n));
    end
    R(lag+1)=temp; %store final value of R
end
R = [conj(fliplr(R(2:end))) R] %apply Hermitian symmetry
%% Option 2) conj(x(n-lag))*x(n)
R_alternative=zeros(1,N); %space for lag=0,1,...N-1
R_alternative(1)=sum(abs(x).^2); %R(0) is the energy
for lag=1:N-1 %for each positive lag
    temp = 0; %partial value of R
    for n=lag+1:N %vary n over valid products
        temp = temp + conj(x(n-lag))*x(n);
    end
    R_alternative(lag+1)=temp; %store final value of R
end
%apply Hermitian symmetry:
R_alternative = [conj(fliplr(R_alternative(2:end))) R_alternative] 
error1 = R - xcorr(x) %compare with xcorr
error2 = R - R_alternative %compare the 2 alternatives