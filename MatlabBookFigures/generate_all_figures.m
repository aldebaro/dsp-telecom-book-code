%generate all figures
%convention:
%figs_CHAPTER_figureName.m
%Check the directory. Files below are ordered by name.

%Choose fonts. From:
%http://www.math.ufl.edu/help/matlab/tec2.6.html
%disabled because does not work for the text in axis labels
%set(0, 'DefaultTextFontName', 'Courier')
clear all
close all
more off %in case it is on

%add entries to PATH if necessary
if 0
    addpath 'C:\svns\laps\latex\dslbook\Applications\GSM_PHY_Analysis' -END
    %thisPath = mfilename('fullpath'); %(AK: I do not think it is working...)
    thisPath = path;
    [pathStr, name, ext] = fileparts(thisPath);
    temp=strrep(pathStr, 'MatlabBookFigures', 'MatlabOctaveFunctions');
    path(temp,path);
    temp=strrep(pathStr, 'MatlabBookFigures', 'MatlabThirdPartyFunctions');
    path(temp,path);
    savepath
end

%signals
figs_signals_conversion
figs_signals_correlation
figs_signals_correlationcoeff
figs_signals_impulsetrain
figs_signals_quantizer
figs_signals_periodic
figs_signals_randomprocesses
figs_signals_taxonomy
%figs_signals_exercises %AK, saiu?

%transforms
figs_transforms_pcacomparison
figs_transforms_dctbasis
figs_transforms_dcthaar_example
figs_transforms_dctimagecoding
figs_transforms_dft
figs_transforms_fourierseries
figs_transforms_dtfs_pulse
figs_transforms_haarbasis
figs_transforms_vectors
figs_transforms_fskconstellation
figs_transforms_qamconstellation
figs_transforms_zvulcanos
figs_transforms_svulcanos
figs_transforms_laplacebasis
figs_transforms_projection

%systems
figs_systems_filters
figs_systems_linearsystems
figs_systems_lti
figs_systems_filters_masks
figs_systems_loopback_measurements
figs_systems_qfactor
figs_systems_bilinear
figs_systems_elliptic
figs_systems_fir
figs_systems_minphase
figs_systems_linearphase
figs_systems_filtering
figs_systems_fixed_point
figs_systems_roundoffErrors;
figs_systems_system_identification
figs_systems_dac_reconstruction
figs_systems_second_order
figs_systems_multirate

%frequency - spectral analysis
figs_spectral_whitenoise
figs_spectral_xcorr_psd
figs_spectral_windows
figs_spectral_periodogram
figs_spectral_spectrograms
figs_spectral_dtmf

%digital communications
figs_digi_comm_awgn_decomposition
figs_digi_comm_correlative_decoding
figs_digicomm_regeneration
figs_digicomm_pamask
%figs_digicomm_pam_psds %AK: saiu?
figs_digicomm_binarymodulations
figs_digicomm_fdm_passband_signals
figs_digicomm_qam
figs_digicomm_matchedfilter_spectra
figs_digicomm_nyquist_criterion
figs_digicomm_line_codes
figs_digicomm_psd_nr_unipolar
figs_digicomm_cyclostationarity
figs_digicomm_constellations
figs_digicomm_more_constellations
figs_digicomm_binaryPAM_ber
figs_digicomm_modulation_comparison
figs_digicomm_awgnReceiver
figs_digicomm_error_probability
figs_digicomm_isi
figs_digicomm_isi2
figs_digicomm_gap
figs_digicomm_eyediagram
figs_digicomm_enbw

figs_channel_convexity
figs_channel_waterfill
figs_channel_isi %see also figs_digicomm_isi and figs_digicomm_isi2

%Synchronism
figs_synchronism_carrier_recovery %for QAM, single curve
figs_channel_pam_offsets %for PAM
figs_channel_qam_offsets %for QAM

%GSM
figs_gsm_freq_correction
figs_gsm_synchronism

%multicarrier and DSL

%figs_multicarrier_oneuser %AK, saiu?

%appendices
figs_app_impulse
figs_app_plot_qvalues
figs_app_probability
figs_app_probability_modulated_noise
figs_app_random_processes_taxonomy

%applications
%If scriptname contains the full pathname to the script file, then
%run changes the current directory to be the one in which the script
%file resides, executes the script, and sets the current directory back
%to what it was.
run('../Applications/ECGTransformCoding/figs_ecgapplication');
run('../Applications/FSKSynchronous/figs_fskapplication');
run('../Applications/QAMSynchronous/figs_qamapplication');
run('../Applications/AMDemodulation/figs_amDemodulationApplication');
run('../Applications/AMonUSRP/figs_AMonUSRPApplication');
close all
disp('Finished generating all figures!')
