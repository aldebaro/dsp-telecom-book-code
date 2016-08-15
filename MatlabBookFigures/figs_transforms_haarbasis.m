%generate figure with Haar basis functions
N=32;

mydir = pwd;
cd('../MatlabThirdPartyFunctions/');
Ah=haarmtx(N);
cd(mydir);
A=Ah'; %the inverse is the Hermitian

%%%%%%%% first basis %%%%%%
clf
plot(0:N-1,A(:,1:4),'-x');
hold on
plot(0:N-1,A(:,N),'k-o');
xlabel('n');

% Create legend
mylegend = legend('k=0','k=1','k=2','k=3','k=31');
set(mylegend,'Position',[0.354 0.1583 0.1554 0.1889]);

writeEPS('firsthaarbasis','font12Only');

%%%%%%%% last basis %%%%%%
clf
plot(0:N-1,A(:,1),'-x');
hold on
plot(0:N-1,A(:,17),'k-o');
plot(0:N-1,A(:,N-3:N),'-o');
xlabel('n');

% Create legend
mylegend = legend('k=0','k=17','k=28','k=29','k=30','k=31');
set(mylegend,'Position',[0.354 0.183 0.1554 0.1889]);

writeEPS('lasthaarbasis','font12Only');