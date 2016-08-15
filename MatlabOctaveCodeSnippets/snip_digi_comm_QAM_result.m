%Plot constellation (ys has been previously defined):
plot(real(ys),imag(ys),'x','markersize',20); %received
hold on, plot(real(qamSymbols),imag(qamSymbols),'or'); %transmitted
axis equal; axis([-4 4 -4 4]); %force axis to have same lengths
title('Transmitted (o) and received (x) constellations');
xlabel('Real part of QAM symbol m_i');
ylabel('Imaginary part of QAM symbol m_q');

