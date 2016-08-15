function qamConst=ak_qamSquareConstellation(M)
% function qamConst=ak_qamSquareConstellation(M)
%Generates a QAM square constellation with M symbols.
if M<4
    error('Number M of symbols must be >= 4');
end
b=log2(M);
b_i = ceil(b/2); %number of bits for in-phase component
b_q = b-b_i; %remaining bits are for quadrature component
M_i = 2^b_i;
M_q = 2^b_q;
pamConst_i = -(M_i-1):2:M_i-1; %use PAM constellation
pamConst_q = -(M_q-1):2:M_q-1; %use PAM constellation
qamConst = zeros(M_q, M_i); %pre-allocate space
for i=1:M_q
    for k=1:M_i
        qamConst(i,k)=pamConst_i(k)+j*pamConst_q(i);
    end
end
qamConst=transpose(qamConst(:)); %make it a row vector