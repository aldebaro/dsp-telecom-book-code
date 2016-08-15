% Study the gap approximation for uncoded PAM and QAM
%Page 68, Eq. (1.277) in Cioffi's, but is not explained there
clear all, close all
%Use QAM in the 2 first examples and PAM in the third

%1)
SNR_db = 10; %relatively low SNR in dB
b=[2:0.25:5]; %number of bits for QAM
SNR = 10^(SNR_db/10); %convert to linear
M = 2.^b; %number of symbols
%Get Pe:
temp = (1-1./sqrt(M)).*qfunc(sqrt(3*SNR./(M-1))); %temporary variable
Pe_qam = 4*(temp - temp.^2);

%The gap approximation
Gamma_qam = (1/3)*(qfuncinv(Pe_qam/4).^2);
b_gap_qam = log2(1+SNR./Gamma_qam);

%Get the Pe with the # bits suggested by the gap approx.
M = 2.^b_gap_qam;
temp = (1-1./sqrt(M)).*qfunc(sqrt(3*SNR./(M-1)));
Pe_estimated = 4*(temp - temp.^2);

%First plot
semilogx(Pe_qam, b,'k-x',Pe_qam, b_gap_qam,'r-o');
legend1 = legend('$b$ (correct)','$\hat b$ (using gap)');
grid; ylabel('b (bits)')
xlabel('Desired P_e'), title(['SNR = ' num2str(SNR_db) ' dB'])
set(legend1,'Interpreter','latex',...
    'Position',[0.16187169312169 0.714671516754862 0.301587301587301 0.169146825396826])
writeEPS('qamgap','legendInLatex');

%2) 2nd plot
clear all
SNR_db = 5; %high SNR in dB
b=[1:0.25:6]; %number of bits for QAM
SNR = 10^(SNR_db/10); %convert to linear
M = 2.^b; %number of symbols
%Get Pe:
temp = (1-1./sqrt(M)).*qfunc(sqrt(3*SNR./(M-1))); %temporary variable
Pe_qam = 4*(temp - temp.^2);

%The gap approximation
Gamma_qam = (1/3)*(qfuncinv(Pe_qam/4).^2);
b_gap_qam = log2(1+SNR./Gamma_qam);

%Get the Pe with the # bits suggested by the gap approx.
M = 2.^b_gap_qam;
temp = (1-1./sqrt(M)).*qfunc(sqrt(3*SNR./(M-1)));
Pe_estimated = 4*(temp - temp.^2);

%First plot
semilogx(Pe_qam, b,'k-x',Pe_qam, b_gap_qam,'r-o');
legend1 = legend('$b$ (correct)','$\hat b$ (using gap)');
grid; ylabel('b (bits)')
xlabel('Desired P_e'), title(['SNR = ' num2str(SNR_db) ' dB'])
set(legend1,'Interpreter','latex',...
    'Position',[0.16187169312169 0.714671516754862 0.301587301587301 0.169146825396826])
writeEPS('gap2','legendInLatex');

%Third plot (for PAM)
clear all
SNR_db = 10; %low SNR in dB
SNR = 10^(SNR_db/10); %convert to linear
b = 1:0.5:5;
M=2.^b; %adopt number of bits suggested by approximation
temp = 2 * qfunc(sqrt(3*SNR./(M.^2-1))); %parcel for PAM
p1 = temp; %estimated probability of error (Pe)
p2 = (1./M) .* temp; %parcel that is discarded
Pe = p1 - p2; %correct (exact) Pe
semilogy(b,Pe,'x-',b,p1,'o-',b,p2,'v-')
xlabel('b'), title(['SNR = ' num2str(SNR_db) ' dB'])
legend1 = legend('$P_e$ (correct)','$\hat P_e$ (estimated)','${\hat P_e} - P_e$ (error)');
set(legend1,'Interpreter','latex',...
    'Position',[0.31588955026455 0.216049382716051 0.28968253968254 0.222332451499118]);
grid
writeEPS('pamgap','legendInLatex');

%4th plot
SNR_db = 30; %low SNR in dB
SNR = 10^(SNR_db/10); %convert to linear
b = 3:0.5:8;
M=2.^b; %adopt number of bits suggested by approximation
temp = 2 * qfunc(sqrt(3*SNR./(M.^2-1))); %parcel for PAM
p1 = temp; %estimated probability of error (Pe)
p2 = (1./M) .* temp; %parcel that is discarded
Pe = p1 - p2; %correct (exact) Pe
semilogy(b,Pe,'x-',b,p1,'o-',b,p2,'v-')
xlabel('b'), title(['SNR = ' num2str(SNR_db) ' dB'])
legend1 = legend('$P_e$ (correct)','$\hat P_e$ (estimated)','${\hat P_e} - P_e$ (error)');
set(legend1,'Interpreter','latex',...
    'Position',[0.31588955026455 0.216049382716051 0.28968253968254 0.222332451499118]);
grid
writeEPS('pamgapHighSNR','legendInLatex');

%%PART II - plots with QAM and PAM to illustrate
%QAM
clear all
SNR_db=2
SNR = 10^(SNR_db/10)
b=[1:0.5:8]; %for QAM
M = 2.^b;
temp = (1-1./sqrt(M)).*qfunc(sqrt(3*SNR./(M-1)));
Pe_qam = 4*(temp - temp.^2);
%The gap approximation
Gamma_qam = (1/3)*(qfuncinv(Pe_qam/4).^2);
b_gap_qam = log2(1+SNR./Gamma_qam)
figure(1)
%loglog(Pe_bar_qam, b_bar,'k-x',Pe_bar_qam, b_gap,'r-o');
semilogx(Pe_qam, b,'k-x',Pe_qam, b_gap_qam,'r-o');
grid; xlabel('Pe'); ylabel('b (bits)')
title('QAM')
legend('Correct','Gap approximation')
%writeEPS('qamgap');

%figure(2)
stem(Pe_qam, b-b_gap_qam)
xlabel('Pe'); ylabel('error in b for the gap approximation')
title('QAM');

%PAM
clear all
SNR_db=20
SNR = 10^(SNR_db/10)
b=[2:0.5:8]; %for PAM
M = 2.^b;
Pe_pam = 2*(1-1./M).*qfunc(sqrt(3*SNR./(M.^2-1)));
Gamma_pam = (1/3)*(qfuncinv(Pe_pam/2).^2);
b_gap_pam = 0.5*log2(1+SNR./Gamma_pam)

%figure(3)
%loglog(Pe_bar_qam, b_bar,'k-x',Pe_bar_qam, b_gap,'r-o');
semilogx(Pe_pam, b,'k-x',Pe_pam, b_gap_pam,'r-o');
grid; xlabel('Pe'); ylabel('b (bits)')
title('PAM')
legend('Correct','Gap approximation')
%writeEPS('pamgap');

%figure(4)
stem(Pe_pam, b-b_gap_pam)
xlabel('Pe'); ylabel('error in b for the gap approximation')
title('PAM')

%PART III
%fixed Pe. this is not a good simulation. should use some optimization
%to search for the b instead of using a linear grid
%using the numbers below, the Pe error was: best =4.0497e-013
%using QAM
clear all
Pe = 10^(-5);
Gamma = (1/3)*(qfuncinv(Pe/4).^2);
N=10;
SNRdBs = linspace(10,30,N);
b = zeros(1,N);
bgap = zeros(1,N);
for i=1:N
    SNR = 10^(SNRdBs(i)/10); %to linear scale
    bgap(i) = log2(1+SNR/Gamma);
    %search for correct b
    M=1000;
    bs = linspace(max(1,bgap(i)-0.5),max(2,bgap(i)+0.5),M);
    best = 1e30;
    for j=1:M
        bcandidate = bs(j);
        M = 2^bcandidate;
        temp = (1-1/sqrt(M)).*qfunc(sqrt(3*SNR/(M-1)));
        Pe_candidate = 4*(temp - temp.^2);
        errorPe = abs(Pe_candidate-Pe);
        if errorPe < best
            best = errorPe;
            b(i) = bcandidate;
        end
    end
    
    M=1000000;
    bs = linspace(max(1,b(i)-0.01),max(2,b(i)+0.01),M);
    best = 1e30;
    for j=1:M
        bcandidate = bs(j);
        M = 2^bcandidate;
        temp = (1-1/sqrt(M)).*qfunc(sqrt(3*SNR/(M-1)));
        Pe_candidate = 4*(temp - temp.^2);
        errorPe = abs(Pe_candidate-Pe);
        if errorPe < best
            best = errorPe;
            b(i) = bcandidate;
        end
    end
    
    %best
    %b(i)
end

%figure(5)
plot(SNRdBs,b,SNRdBs,bgap);
xlabel('SNR (dB)'); ylabel('b (bits)');
legend('Correct','Gap approximation')
%writeEPS('gap2');