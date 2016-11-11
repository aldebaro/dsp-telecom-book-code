%Calculate the unscaled autocorrelation R(i) of x
x=[1+j 2 3] %define some vector x to test the code
N=length(x);
R=zeros(1,N); %space for i=0,1,...N-1
R(1)=sum(abs(x).^2); %R(0) is the energy
for i=1:N-1 %for each positive lag
    temp = 0; %partial value of R
    for n=1:N-i %vary n over valid products
        temp = temp + x(n+i)*conj(x(n));
    end
    R(i+1)=temp; %store final value of R
end
R = [conj(fliplr(R(2:end)))] %append complex conjugate

