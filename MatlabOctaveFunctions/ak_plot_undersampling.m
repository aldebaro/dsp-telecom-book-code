function ak_plot_undersampling(fc,fs,bw,Nimp)
% function ak_plot_undersampling(fc,fs,bw,Nimp)
%Plots several replica of signal with bandwidth BW and centered
%at frequency fc, when sampled at fs.
%fc - central (or carrier) frequency
%fs - sampling frequency
%bw - bandwidth of the baseband signal, assuming its twice at fc (DSB
%signal)
%Nimp - number of impulses at each side of DC frequency (2*Nimp+1 impulses
%will be assumed when plotting)

if nargin < 4
    Nimp = 3; %number of impulses at each side of DC frequency
end

%Number of impulses in the train that represents the sampling operation
m=round(fc/fs); %approximately the factor to mutiply fs to get to fc

%convolution of signal replica at positive frequency fc with impulses
temp = fs * (-m+(-Nimp:Nimp)); %impulse train at multiples of fs
positive_freqs = temp + fc;

%convolution of signal replica at negative frequency -fc with impulses
temp = fs * (m+(-Nimp:Nimp)); %impulse train at multiples of fs
negative_freqs = temp - fc;

lowest_freq = min(negative_freqs);
highes_freq = max(positive_freqs);

f=linspace(lowest_freq,highes_freq,1000);
y=zeros(size(f));

%% Plot replicas
clf
plot(f,y)
hold on
baseBandSignalSketch=[0.1 1 2 3 3 3 0.1]; %this is arbitrary, just for visualization
maxSketchValue=4; %for visualization only
%we assume the signal occupies [-bw, bw] (twice) bw when centered at fc
signal_freqs = linspace(-bw,bw,length(baseBandSignalSketch));
for i=1:length(temp)
    plot(signal_freqs+positive_freqs(i), baseBandSignalSketch, 'b*-', ...
        signal_freqs+negative_freqs(i), fliplr(baseBandSignalSketch), 'k-o')
end
xlabel('frequency (Hz)')
title(['Fs = ' num2str(fs) ' Hz. Replicas from positive and negative bands are in blue and black. Note if phase inversion occurred.'])
tt=axis;
tt(4) = maxSketchValue; 
axis(tt);
grid
hold off

%% Do some postprocessing to provide information
positivesLower = -bw + positive_freqs;
positivesUpper = bw + positive_freqs;

negativesLower = -bw/2 + negative_freqs;
negativesUpper = bw/2 + negative_freqs;

%first positive band
indicesPositives = positivesLower > 0;
templ = positivesLower(indicesPositives);
tempu = positivesUpper(indicesPositives);
firstPositiveBand = [templ(1) tempu(1)]

indicesPositives = negativesLower > 0;
templ = negativesLower(indicesPositives);
tempu = negativesUpper(indicesPositives);
if numel(tempu) == 0 | numel(templ) == 0
    warning(['Value of fs = ' num2str(fs) ' does not allow overlap of spectra. Increase the number of impulses.'])
    return
end
firstNegativeBand = [templ(1) tempu(1)]

disp('Aliases of positive band');
disp(num2str([positivesLower; positivesUpper]))

disp('Aliases of negative band')
disp(num2str([negativesLower;negativesUpper]))

disp(['Value of fs = ' num2str(fs)])
end