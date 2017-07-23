1) Original files with GSM digitized data:
 
The eight (8) .cfile files from the GSM Scanner Project are in GSMSignalFiles.zip. The GSMSP challenge provided GSM waveforms to be decoded. Results obtained by Mr. Tore for the challenge were releasesd at the GSMSP page. He showed how to interpret the GSM waveforms using modified GSMsim Octave / Matlab code. The original Matlab/Octave .m files are in GSMSPcode.zip.  Read The_Beginners_Guide_to_analyzing_GSM_data_in_MatLab.pdf also in GSMSPcode.zip.

In the GSMSignalFiles.zip you can find 8 GSM waveforms: GSMSP_20070204_robert_dbsrx_937MHz_16.cfile, 
GSMSP_20070204_robert_dbsrx_941.0MHz_128.cfile, 
GSMSP_20070204_robert_dbsrx_941MHz_16.cfile, 
GSMSP_20070204_robert_dbsrx_953.6MHz_128.cfile, 
GSMSP_20070204_robert_dbsrx_953.6MHz_64.cfile, 
GSMSP_20070218_robert_dbsrx_941MHz_112.cfile, 
GSMSP_20070319_tore_957425000_64.cfile and
GSMSP_20070406_steve_940.4Mhz_118.cfile. 

You can use the code modified at UFPA (see below). But if you want to execute the original Tore's code, unzip GSMSPcode.zip and execute the scripts step1.m, step2.m and step3.m.

URLs related to the GSMSP challenge (do not seem to be active):
http://www.segfault.net/gsm/resources  

http://scratchpad.wikia.com/wiki/Gsm 

http://wiki.thc.org/gsm - The original GSM Scanner Project (GSMSP) homepage

https://www.thc.org/

2) Modifications made at UFPA

I added some comments and tried to make the code clearer to our students. These versions have the prefix ak_ and you can run script ak_runAllSteps.m to execute these modified versions. To learn about the cfiles, execute ak_investigateAllFiles.m.
