bi=7; % number of bits for integer part
bf=8; % number of bits for decimal part
Bq=fixed(bi,bf,B); %quantize coefficients of B(z) using Q7.8
Aq=fixed(bi,bf,A); %quantize coefficients of A(z) using Q7.8

