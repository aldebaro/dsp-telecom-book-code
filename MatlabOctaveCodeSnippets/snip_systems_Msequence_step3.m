Rsegment = R(maxIndex-M:maxIndex+M)/maxR; %segment of R
X=convmtx(Rsegment,length(h)); %convolution matrix
z3=X*h; %convolution center of z3 is equal to center of z
h_hat2 = z3(M+1:2*M+1) %equal to h_hat
A=X'*X %note it is approximately the identity matrix

