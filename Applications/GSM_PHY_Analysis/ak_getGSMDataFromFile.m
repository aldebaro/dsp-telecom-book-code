function [signal, information] = ...
    ak_getGSMDataFromFile(fileNumber, folder, verbosity)

if nargin < 3
    verbosity = 1;
end
if nargin < 2
    folder = '';
end

% Select the file to analyze
switch fileNumber
    case 1
        fileName='GSMSP_20070204_robert_dbsrx_937MHz_16.cfile';
        decimationFactor = 16;
        information.fcenterMHz=937; %center frequency in MHz
    case 2
        fileName='GSMSP_20070204_robert_dbsrx_941MHz_16.cfile';
        decimationFactor = 16;
        information.fcenterMHz=941; %center frequency in MHz
    case 3
        fileName='GSMSP_20070204_robert_dbsrx_953.6MHz_64.cfile';
        decimationFactor = 64;
        information.fcenterMHz=953.6; %center frequency in MHz
    case 4
        fileName='GSMSP_20070319_tore_957425000_64.cfile';
        decimationFactor = 64;
        information.fcenterMHz=957.425; %center frequency in MHz
    case 5
        fileName='GSMSP_20070218_robert_dbsrx_941MHz_112.cfile';
        decimationFactor = 112;
        information.fcenterMHz=941; %center frequency in MHz
    case 6
        fileName='GSMSP_20070406_steve_940.4Mhz_118.cfile';
        decimationFactor = 118;
        information.fcenterMHz=940.4; %center frequency in MHz
    case 7
        fileName='GSMSP_20070204_robert_dbsrx_941.0MHz_128.cfile';
        decimationFactor = 128;
        information.fcenterMHz=941; %center frequency in MHz
    case 8
        fileName='GSMSP_20070204_robert_dbsrx_953.6MHz_128.cfile';
        decimationFactor = 128;
        information.fcenterMHz=953.6; %center frequency in MHz
    otherwise
        error(['File index ' num2str(fileNumber) ' not found!']);
end

fullPath = [folder fileName]; %concatenate the folder as prefix

%Note the integer number before .cfile is the decimation factor
%of an original sampling frequency of 64 MHz, such that _128.cfile
%indicates the signal has sampling frequency of 64e6/128=500e3
information.sampleRate = 64e6/decimationFactor; %in Hz

signal = read_complex_binary(fullPath);
information.fullPath = fullPath;

information.signalDuration=length(signal)/information.sampleRate;
%get file size in Mbytes
file=dir(fullPath);
information.fileSizeInMB=file.bytes/(1024^2);

if verbosity>0
    multiframe51Duration = 235.38e-3; %duration of multiframe
    multiframe26Duration = 120e-3; %duration of multiframe
    
    disp(['------ Processing file #' num2str(fileNumber)])
    disp([fileName ' at ' folder]);
    disp(['File size = ' num2str(information.fileSizeInMB) ' MBytes'])
    disp(['Sampling rate = ' num2str(information.sampleRate/1e3) ' kHz'])
    disp(['Center frequency = ' num2str(information.fcenterMHz) ' MHz'])
    disp(['Signal duration in samples = ' num2str(length(signal))])
    disp(['Signal duration = ' num2str(information.signalDuration) ' sec'])
    disp([num2str(information.signalDuration/multiframe26Duration) ' 26-frames multiframes'])
    disp([num2str(information.signalDuration/multiframe51Duration) ' 51-frames multiframes'])
end
