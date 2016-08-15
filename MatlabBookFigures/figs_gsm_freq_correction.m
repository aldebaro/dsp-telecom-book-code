clear all
clf
%add path to GSM scripts
P=path;
path(P,'../../Applications/GSM_PHY_Analysis');
ex_gsm_freq_correction

subplot(131)
plot(n,real(x)) %plot to note that FB is a pure sine
axis tight, title('a)')
subplot(132)
plot(real(sq),imag(sq),'x') %received constellation
axis equal, title('b)')
subplot(133)
plot(real(sq_corrected),imag(sq_corrected ),'x')%corrected
axis equal, title('c)')

writeEPS('gsm_freq_correction')

%run the analysis of the GSMP challenge
gsm_setGlobalVariables
ak_step1a
writeEPS('gsm_usrp_psds');

ak_step1b
writeEPS('gsm_usrp_bcch_location','font12Only');

ak_step1c
writeEPS('gsm_usrp_freq_offset'); %,'font12Only');
