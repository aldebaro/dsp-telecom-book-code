M=64; %modulation order
constellation=ak_qamSquareConstellation(M); %QAM constellation
Ec=mean(abs(constellation).^2); %average energy constellation
N=10000; %number of random symbols
SNRdB=8; %desired SNR in dB
noisePower=Ec/(10^(0.1*SNRdB));%total noise power, half per dimension
indicesTx=ceil(M*rand(1,N)); %indices, check with: hist(indices,M)
transmitSymbols=constellation(indicesTx); %correct symbols
noise=sqrt(noisePower/2)*(randn(1,N)+1j*randn(1,N)); %noise (complex)
receiveSymbols=transmitSymbols+noise; %symbol-based AWGN channel
%% 1st option) Using the correct transmit symbols as reference
evm=ak_evm(transmitSymbols, receiveSymbols); %estimate RMS EVM (%)
mer=ak_mer(transmitSymbols, receiveSymbols); %estimate MER (dB)
mer2=10*log10(1/(evm/100)^2); %MER calculated from EVM
disp(['EVM=' num2str(evm) '%, MER=' num2str(mer) ' dB (correct)'])
%% 2nd option) Using the estimated transmit symbols as reference
[indicesRx, estimatedSymbols]=ak_qamdemod(receiveSymbols,M);
evm_est=ak_evm(estimatedSymbols, receiveSymbols); %estim. RMS EVM (%)
mer_est=ak_mer(estimatedSymbols, receiveSymbols); %estimate MER (dB)
disp(['EVM=' num2str(evm_est) '%, MER=' num2str(mer_est) ' dB'])
%% Other figures of merit
snr=10*log10(mean(abs(transmitSymbols).^2)/mean(abs(noise).^2)); %SNR
ser=sum(indicesRx+1 ~= indicesTx)/length(indicesTx); %estimate SER
disp(['SNR=' num2str(snr) ' dB, SER=' num2str(ser) '%'])
plot(real(receiveSymbols),imag(receiveSymbols),'x'), hold on
plot(real(constellation),imag(constellation),'or')