%Plot constellation:
plot(real(ys),imag(ys),'x','markersize',20); %received
hold on
plot(real(qamSymbols),imag(qamSymbols),'or'); %transmitted
axis equal; %make constellation on square
axis([-4 4 -4 4]) 
title('Transmitted (o) and received (x) constellations');
xlabel('Real part of QAM symbol m_i');
ylabel('Imaginary part of QAM symbol m_q');

