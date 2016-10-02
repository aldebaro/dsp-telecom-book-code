%Simple script for (binary) FSK with synchronous demodulation.
%The bit 0 is represented by f0 Hz and bit 1 by f1 Hz.
%Note a "mark" is a 1-bit (or logic 1) and a "space"
%is a 0-bit (or logic 0).
%The frequencies will be the ones used in the ITU-T V.21 modem:
%980-Hz Mark, 1180-Hz Space for Transmit Originate (modem that called)
%1650-Hz Mark, 1850-Hz Space for Transmit Answer
%1650-Hz Mark, 1850-Hz Space for Receive Originate
%980-Hz Mark, 1180-Hz Space for Receive Answer
%Because it is binary, there is one bit per symbol.

%%%%%%%%%%%%%%%%%%%
%Basic configuration
%%%%%%%%%%%%%%%%%%%
clear all; close all
showPlots = 1   %showPlots if equal to 1 (use 0 to disable)
if 1 %choose between two options
    f0 = 980;   %freq. do bit 0
    f1 = 1180;   %freq. do bit 1
else
    f0 = 1650; %freq. do bit 0
    f1 = 1850;   %freq. do bit 1
end
fsymbol = 300; %100;  %symbol frequency, the rate is R = 1/fsymbol
%(in symbols/sec or bauds)
Fs = 9600; %8000;   %sampling frequency in Hz
T_symbolDuration = 1/fsymbol;

%%%%%%%%%%%%%%%%%%%
%Obtain the input bitstream inputBits
%%%%%%%%%%%%%%%%%%%
if 1
    %use a binary image, with pixels represented by 0 or 1
    inputImage=load('./fsk_data/image.txt');  %load image from file
    inputBits=inputImage(:);   %convert matrix to a column vector
else
    %alternatively, one can test with a small vector:
    inputBits=[1 0 1 0 1 1 1 0]';
    inputImage=[];
end
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
N_samplesPerSymbol = length(basis0); %number of samples per symbol, also
%known as "oversampling" factor
%create the symbol constellation with 2 symbols
X0 = [1; 0];
X1 = [0; 1];
%check whether or not orthonormal
if ~ak_areColumnsOrthonormal(A)
    warning('Basis functions are not orthonormal!');
end

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
if 0
    y_total = x_total; %Received = transmitted
else
    y_total = x_total + 0.1*randn(size(x_total)); %add Gaussian noise
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

if showPlots
    if (~isempty(inputImage))
        %show the images
        imagesc(inputImage); title('Original image'); pause %show image
        [Nrow, Ncolumns] = size(inputImage);
        receivedImage=reshape(outputBits,Nrow, Ncolumns);
        imagesc(receivedImage); title('Received image');
        pause
        imagesc(inputImage - receivedImage); title('Error image');
        pause
    end
    %show the constellations
    plot(receivedCoefficients(1,:),receivedCoefficients(2,:),'x',...
        'MarkerSize',16); hold on
    plot(X0(1),X0(2),'or','MarkerSize',12); 
    plot(X1(1),X1(2),'or','MarkerSize',12);
    title('Transmit ("o") and received ("x") constellations');
    xlabel('Coefficient of basis 0 (f0)');
    ylabel('Coefficient of basis 1 (f1)');
    grid
    axis([-0.2 1.2 -0.2 1.2])
end

