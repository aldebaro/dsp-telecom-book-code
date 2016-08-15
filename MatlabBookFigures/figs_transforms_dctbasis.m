%generate figure with DCT basis functions
N=32;

Ah=ak_dctmtx(N);
A=Ah'; %the inverse is the Hermitian
clf
plot(0:N-1,A(:,1:3),'-x');
hold on
plot(0:N-1,A(:,N),'k-o');
xlabel('n');

% Create legend
mylegend = legend('k=0','k=1','k=2','k=31');
set(mylegend,'Position',[0.7354 0.1583 0.1554 0.1889]);

writeEPS('dctbasis');