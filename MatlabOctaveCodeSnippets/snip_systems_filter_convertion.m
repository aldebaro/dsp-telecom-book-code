N = 5; %filter order
[B,A] = butter(N,1,'s'); %prototype with cutoff=1 rad/s
[Bnew,Anew]=lp2lp(B,A,100); %convert to cutoff=100 rad/s
freqs(Bnew,Anew) %plot mag (linear scale) and phase

