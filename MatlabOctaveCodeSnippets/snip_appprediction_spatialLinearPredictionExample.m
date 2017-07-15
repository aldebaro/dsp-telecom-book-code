%Example 10-11 from Barry, 2004 (note a typo in matrix R in the book)
Ryy=[16 8 4; 8 20 10; 4 10 21] %noise autocorrelation, correlated
%Ryy=[10, 8, 2; 8 10 10; 2 10 10]; %another option, higher gain
[L D] = ldl_dg(Ryy)%own LDL, do not use chol(A) because it swaps rows
Ryy-L*D*L' %compare with Ryy, should be the same
P=eye(size(L))-inv(L) %optimum MMSE linear predictor
minMSE=trace(D) %minimum MSE is the trace{Ree} = trace{D}
sumPowerX=trace(Ryy); %sum of all "users"
predictionGain = 10*log10(sumPowerX/minMSE)
