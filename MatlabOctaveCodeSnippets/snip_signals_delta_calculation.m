N=300; delta_x=zeros(1,N); x=linspace(-8,8,N); %define range
%use loops to be compatible with Octave. Matlab allows delta_x=eps(x)
for i=1:N, delta_x(i) = eps(single(x(i))); end %single precision
semilogy(x,delta_x); hold on
for i=1:N, delta_x(i) = eps(x(i)); end  %double precision
semilogy(x,delta_x,'r:'); legend('float','double'); grid

