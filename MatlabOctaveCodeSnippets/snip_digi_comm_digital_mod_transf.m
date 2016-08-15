S=32;       %number of samples per symbol
Period=8;   %period of sinusoids
n=(0:S-1)'; %time index
%inverse matrix:
A=[cos(2*pi/Period*n) sin(2*pi/Period*n)]*sqrt(2/S); 
innerProduct=sum(A(:,1).*A(:,2)) %are columns orthogonal?
if 1  %test two alternatives to obtain Ah from A
	Ah=A'; %the pseudoinverse is the Hermitian
else
	Ah=pinv(A); %equivalently, use pseudoinverse function
end
Ac=3; As=-1;
x=Ac*A(:,1)+As*A(:,2); %compose the signal in time domain
X=Ah*x  %demodulation at the receiver: recover amplitudes

