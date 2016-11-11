N=256; %number of samples available of x1 and x2
n=0:N-1; %abscissa
kweak=32; %FFT bin where the weak cosine is located
kstrong1=38; %FFT bin for strong cosine in x1
weakSigal = 1*cos((2*pi*kweak/N)*n+pi/3); %common parcel
x1=100*cos((2*pi*kstrong1/N)*n+pi/4) + weakSigal; %x1[n]
kstrong2=37.5; %location for strong cosine in x2
x2=100*cos((2*pi*kstrong2/N)*n+pi/4) + weakSigal; %x2[n]

