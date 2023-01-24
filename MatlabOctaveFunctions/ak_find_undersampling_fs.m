%Notation based on reference:
%[1] https://en.wikipedia.org/wiki/Undersampling
fc=600e6; %central (carrier) frequency in Hz
BW=10e3; %baseband (from 0 to maximum frequency) bandwidth in Hz
fh=fc+BW; %assume a double-sided band (DSB) signal
fl=fc-BW;

%Find the minimum sampling frequency according to [1]:
nmax=floor(fh/(fh-fl))
fsmin=2*fh/nmax
fsmax=2*fl/(nmax-1)

%Because the minimum fs may require ideal filters, find some other options:
%impose the step (resolution) of this analysis:
N=10; %try N+1 options
delta_n=nmax/N; 
%The choice below may impact phase inversion:
choose_n_even = 0; %use 1 or 0 to choose even or odd values of n. 
if choose_n_even == 1 
    n=0:delta_n:nmax;
    n(1)=2;
else
    n=3:delta_n:nmax;
    n(N+1)=nmax;
end
disp('Some possible sampling frequency fs values:')
fs_options=zeros(N+1,2);
for i=1:N+1
    fs_options(i,1)=2*fh/n(i); %fsmin
    fs_options(i,2)=2*fl/(n(i)-1); %fsmax
    disp(['Range of possible fs=[' num2str(fs_options(i,1)) ', ' ...
        num2str(fs_options(i,2)) '] for n=' num2str(n(i))])
end
%choose some fs within a valid range:
option_chosen=5; %you can make a loop here: for option_chosen=1:N+1
fs=0.5*(fs_options(option_chosen,1)+fs_options(option_chosen,2)); 
ak_plot_undersampling(fc,fs,BW) %now plot 
%in case you made the loop: pause; end