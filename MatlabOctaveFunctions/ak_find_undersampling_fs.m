%Notation based on https://en.wikipedia.org/wiki/Undersampling
fc=600e6; %central (carrier) frequency in Hz
BW=10e3; %baseband (from 0 to maximum frequency) bandwidth in Hz
fh=fc+BW; %assume a double-sided band (DSB) signal
fl=fc-BW;

nmax=floor(fh/(fh-fl))
fsmin=2*fh/nmax
fsmax=2*fl/(nmax-1)

N=10;
delta_n=nmax/N;
n=0:delta_n:nmax;
n(1)=2;

disp('Some possible sampling frequency fs values:')
for i=1:N
    fsmin=2*fh/n(i);
    fsmax=2*fl/(n(i)-1);
    disp(['Range of possible fs=[' num2str(fsmin) ', ' num2str(fsmax) '] for n=' num2str(n(i))])
end    

ak_plot_undersampling(fc,fsmin,BW)