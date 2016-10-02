%script to illustrate how to use the function ak_rddata
%the current path needs to have the following subdirectory:
PATH='./ecg_data'; %directory of interest (where the files are)
%FILENAME='08730_03'; %file name
%FILENAME='11442_01'; %file name
FILENAME='12531_04'; %file name
SAMPLES2READ = inf; %number of samples to read. Use inf for all
shouldPlot = 1; %if 0 does not show plot, but if 1 it does show
%read the signal and store the output in M and TIME. TIME is the time
%instants and M has two ECG channels
[M, TIME] = ak_rddata(PATH, FILENAME, SAMPLES2READ, shouldPlot);
clf
plot(TIME,M(:,1))
hold on
plot(TIME,M(:,2),'r')
xlabel('Time (s)'); ylabel('Voltage (mV)');