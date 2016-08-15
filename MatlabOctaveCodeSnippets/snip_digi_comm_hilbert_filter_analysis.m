w=linspace(-pi,pi,100); %frequency in rad
H=freqz(b,1,w); %calculate frequency response (b has been defined)
H2=H.*exp(j*(N/2)*w); %compensate linear phase
plot(w,angle(H2)/pi*180); %convert to degrees

