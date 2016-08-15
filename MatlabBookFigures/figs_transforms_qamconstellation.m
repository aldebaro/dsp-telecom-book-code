clf
x=-3:2:3; %define possible amplitudes
symbols=[];  %initialize
for in=1:length(x)
    for qu=1:length(x)
        %use complex numbers to facilitate plot
        symbols = [symbols; x(in)+j*x(qu)];
    end
end
%plot
%plot(symbols,'x','markersize',12); hold on
plot(symbols,'o','markersize',14); 
axis([-4 4 -4 4]); grid
%xlabel('Cosine amplitudes A_c')
%ylabel('Sine amplitudes A_s')
xlabel('Real part');
ylabel('Imaginary part');
title('QAM symbols')
writeEPS('qam_constellation')
