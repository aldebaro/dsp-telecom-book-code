%execute this script from its directory or use the function run
%this is needed to find the ECG data files without providing an
%absolute path.
%run changes the current directory to be the one in which the script
%file resides, executes the script, and sets the current directory back
%to what it was.
clf
PATH='./ecg_data'; %directory of interest (where the files are)
FILENAME='12531_04'; %file name
SAMPLES2READ = inf; %number of samples to read. Use inf for all
shouldPlot = 0; %if 0 does not show plot, but if 1 it does show
[M, TIME,sfreq,bitres,gain,zerovalue] = ak_rddata(PATH, FILENAME, SAMPLES2READ, shouldPlot);
N=1500;
plot(TIME(1:N),M(1:N,1))
xlabel('Time (s)'); ylabel('Voltage (mV)');
writeEPS('ecg_signal');
sfreq,bitres,gain,zerovalue
delta = (1/gain(1)) * (10^-3) %quantization step in Volts


clf
x=M(1:250,1);
N=32;
Ainverse=octave_dctmtx(N); %dctmtx outputs matrices for the direct transform
A=inv(Ainverse); %DCT matrix
%simple example of encoding/decoding
K=6; %K is the number of coefficient that should be kept (the
%others are discarded)
X=ak_1dBlockCoding(x,Ainverse,K); %encoding
x2=ak_1dBlockDecoding(X,A,K); %decoding
%analysis
x=x(1:length(x2));
error = x-x2; %calculate the error
abscissa=(1:length(x2))/sfreq;
clf; %clear previous figure, if exists
plot(abscissa,x,'-x',abscissa,x2,'-+',abscissa,error,'-o') %show plots
legend('original','reconstructed','error');
xlabel('Time (s)'); ylabel('Voltage (mV)');
writeEPS('ecg_reconstructedsignal','font12Only');

%rate distortion
clf
[h,signalPower]=ak_testBlockCodingRateDistortionCurve(4);
set(h,'color','blue');
hold on
h=ak_testBlockCodingRateDistortionCurve(8);
set(h,'color','black');
h=ak_testBlockCodingRateDistortionCurve(32);
set(h,'color','green');
h=ak_testBlockCodingRateDistortionCurve(64);
set(h,'color','red');
h=ak_testBlockCodingRateDistortionCurve(128);
set(h,'color','magent');
makedatatip(h,[10]) %example value
legend('N=4','8','32','64','128');

writeEPS('ecg_ratedistortion');

%estimate quantization SNR
RSR = signalPower / ((delta^2)/12)
RSRdB = 10 * log10(RSR) 