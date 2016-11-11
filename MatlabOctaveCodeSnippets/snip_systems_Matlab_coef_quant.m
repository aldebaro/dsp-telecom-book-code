bi=7; % number of bits for integer part
bf=8; % number of bits for decimal part
b=bi+bf+1; %total number of bits, inclusing sign bit
signed=1; %use signed numbers (i.e., not "unsigned")
Bq=fi(B,signed,b,bf); %quantize coefficients of B(z) using Q7.8
Aq=fi(A,signed,b,bf); %quantize coefficients of A(z) using Q7.8
zplane(double(Bq),double(Aq)) %cast to double before manipulating