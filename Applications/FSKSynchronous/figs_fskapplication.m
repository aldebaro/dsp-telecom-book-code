function figs_fskapplication
%Generate figures for:
%Simple script for (binary) FSK with synchronous demodulation.
%The bit 0 is represented by f0 Hz and bit 1 by f1 Hz.

%%%%%%%%%%%%%%%%%%%
%Obtain the input bitstream inputBits
%%%%%%%%%%%%%%%%%%%
%use a binary image, with pixels represented by 0 or 1
inputImage=load('./fsk_data/image.txt');  %load image from file
inputBits=inputImage(:);   %convert matrix to a column vector

%show the image
clf
imagesc(inputImage); title('Original image');
colormap([0 0 0; 1 1 1]);
axis equal
writeEPS('fsk_originalimage');

%example from Texas Instruments implementation of V.21
clf
f0 = 980;   %freq. do bit 0
f1 = 1180;   %freq. do bit 1
fsymbol = 300; %100;  %symbol frequency, the rate is R = 1/fsymbol
%(in symbols/sec or bauds)
Fs = 9600; %8000;   %sampling frequency in Hz
isChannelIdeal = 0; %add noise
plotConstellation(inputBits,f0,f1,fsymbol,Fs,isChannelIdeal)
writeEPS('fsk_nonidealchannel_nonorthogonal');

%example from Texas Instruments implementation of V.21
clf
f0 = 980;   %freq. do bit 0
f1 = 1180;   %freq. do bit 1
fsymbol = 300; %100;  %symbol frequency, the rate is R = 1/fsymbol
%(in symbols/sec or bauds)
Fs = 9600; %8000;   %sampling frequency in Hz
isChannelIdeal = 1; %add noise
plotConstellation(inputBits,f0,f1,fsymbol,Fs,isChannelIdeal)
writeEPS('fsk_idealchannel_nonorthogonal');

%example from Texas Instruments implementation of V.21
clf
f0 = 1650;   %freq. do bit 0
f1 = 1850;   %freq. do bit 1
fsymbol = 100;  %symbol frequency, the rate is R = 1/fsymbol
%(in symbols/sec or bauds)
Fs = 8000;   %sampling frequency in Hz
isChannelIdeal = 0; %add noise
plotConstellation(inputBits,f0,f1,fsymbol,Fs,isChannelIdeal)
writeEPS('fsk_nonidealchannel_orthogonal');

%example from Texas Instruments implementation of V.21
clf
f0 = 1650;   %freq. do bit 0
f1 = 1850;   %freq. do bit 1
fsymbol = 100;  %symbol frequency, the rate is R = 1/fsymbol
%(in symbols/sec or bauds)
Fs = 8000;   %sampling frequency in Hz
isChannelIdeal = 1; %add noise
plotConstellation(inputBits,f0,f1,fsymbol,Fs,isChannelIdeal)
writeEPS('fsk_idealchannel_orthogonal');

end

function plotConstellation(inputBits,f0,f1,fsymbol,Fs,isChannelIdeal)
T_symbolDuration = 1/fsymbol;

%%%%%%%%%%%%%%%%%%%
%Initialize transmitter (modulator)
%%%%%%%%%%%%%%%%%%%
T_sample = 1/Fs; %sampling period in seconds
t = 0:T_sample:T_symbolDuration-T_sample; %discrete-time for one symbol
%create the waveform for each basis function
basis0 = cos(2*pi*f0*t);
basis1 = cos(2*pi*f1*t);
%normalize the basis functions by the norm to obtain unity energy
basis0 = basis0 / sqrt(sum(basis0.^2));
basis1 = basis1 / sqrt(sum(basis1.^2));
%organize bases as columns of a matrix
A=[transpose(basis0) transpose(basis1)];

disp('Power of a basis function');
mean(basis1.^2)

N_samplesPerSymbol = length(basis0); %number of samples per symbol, also
%known as "oversampling" factor
%create the symbol constellation with 2 symbols
X0 = [1; 0];
X1 = [0; 1];

%%%%%%%%%%%%%%%%%%%
%Modulate to transmit
%%%%%%%%%%%%%%%%%%%
N_symbols = length(inputBits); %number of symbols (or bits, because binary)
%pre-allocate space for all message duration:
x_total=zeros(N_samplesPerSymbol, N_symbols);
for i=1:N_symbols  %i is the i-th symbol
    if inputBits(i)==1
        X=X1; %transmit the symbol corresponding to bit 1
    else
        X=X0; %transmit the symbol corresponding to bit 0
    end
    x_total(:,i) = A*X; %modulate via block transform
end
%The idea of using matrix multiplication above is to make a connection
%with transforms. Alternatively, one could simply do as follows:
%for i=1:N_symbols  %i is the i-th symbol
%    if inputBits(i)==1
%        x_total(:,i) = basis1;
%    else
%        x_total(:,i) = basis0;
%    end
%end
x_total = x_total(:);  %make x_total a column vector (for transmission)

%%%%%%%%%%%%%%%%%%%
%Transmit the signal over an ideal channel
%%%%%%%%%%%%%%%%%%%
%in this case the channel does not alter the input signal:
if isChannelIdeal == 1
    y_total = x_total; %Received = transmitted
else
    randn('state',0); %set the seed to repeat the same noise
    noise = 0.1*randn(size(x_total));
    noisePower = mean(noise.^2)
    signalPower = mean(x_total.^2)
    RSRdB = 10*log10(signalPower/noisePower)
    y_total = x_total + noise; %add Gaussian noise
end

%%%%%%%%%%%%%%%%%%%
%Initialize receiver (demodulator)
%%%%%%%%%%%%%%%%%%%
Ah = A'; %assume that A is unitary and the inverse is the Hermitian

%%%%%%%%%%%%%%%%%%%
%Demodulate the received signal
%%%%%%%%%%%%%%%%%%%
%Note that we assume the basis functions were created in the receiver
%with perfect synchronism to the transmitter. Hence, it is an ideal
%"synchronous" reception.
outputBits = zeros(N_symbols,1); %pre-allocate space
receivedCoefficients = zeros(2,N_symbols); %pre-allocate space
%reorganize y_total as a matrix for simplicity
y=reshape(y_total, N_samplesPerSymbol, N_symbols);

for i=1:N_symbols  %i is the i-th symbol
    x=y(:,i);
    %demodulate via block transform ("correlative decoding")
    X = Ah * x; %calculate the inner product with each basis function
    receivedCoefficients(:,i) =X;
    %find the constellation point nearest to the coefficients X:
    distanceToSymbol0 = sqrt(sum( (X-X0).^2 ));
    distanceToSymbol1 = sqrt(sum( (X-X1).^2 ));
    if distanceToSymbol0 < distanceToSymbol1
        outputBits(i) = 0; %symbol 0 is the closest one
    else
        outputBits(i) = 1; %symbol 1 is the closest one
    end
end

%%%%%%%%%%%%%%%%%%%
%Evaluation
%%%%%%%%%%%%%%%%%%%
%count number of de errors:
numErrors = sum(abs(inputBits-outputBits));
BER = 100 * numErrors / length(inputBits);
disp(['BER = ' num2str(BER) ' %']);


%show the constellations
plot(receivedCoefficients(1,:),receivedCoefficients(2,:),'x',...
    'MarkerSize',16); hold on
plot(X0(1),X0(2),'or','MarkerSize',12);
plot(X1(1),X1(2),'or','MarkerSize',12);
title('Transmit ("o") and received ("x") constellations');
xlabel('Coefficient of basis 0 (f0)');
ylabel('Coefficient of basis 1 (f1)');
axis equal
grid
%axis([-0.2 1.2 -0.2 1.2])
end