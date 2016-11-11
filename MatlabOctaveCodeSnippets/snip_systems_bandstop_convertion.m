Wc=0.5; %cutoff (normalized) frequency of prototype filter
Wstop = [0.5 0.8]; %stopband cutoff frequencies
N=3; %order of prototype filter
[B,A] = butter(N,Wc); %Butterworth prototype
[Bnew,Anew]=iirlp2bs(B,A,Wc,Wstop); %Bandstop Butterworth
[B2, A2] = ellip(N, 3, 30, Wc); %Elliptic prototype
[Bnew2,Anew2]=iirlp2bs(B2,A2,Wc,Wstop); %Bandstop elliptic
fvtool(Bnew2, Anew2, Bnew, Anew); %compare freq. responses

