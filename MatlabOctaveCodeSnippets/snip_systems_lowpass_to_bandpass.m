N = 4; %prototype order (bandpass order is 2N = 8)
[B,A] = butter(N,1,'s'); %prototype with cutoff=1 rad/s
[Bnew,Anew]=lp2bp(B,A,50,30); %convert to cutoff=50 and BW=30 rad/s
freqs(Bnew,Anew) %plot mag (linear scale) and phase

