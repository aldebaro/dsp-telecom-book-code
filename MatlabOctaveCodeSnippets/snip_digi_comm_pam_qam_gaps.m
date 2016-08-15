Pe = [2e-5 1e-5 2e-6 1e-6 2e-7 1e-7 2e-8 1e-8 2e-9 1e-9];
argQ_qam = qfuncinv(Pe/4); %QAM
gap_linear_qam = (argQ_qam.^2)/3;
gap_db_qam = 10*log10(gap_linear_qam);
argQ_pam = qfuncinv(Pe/2); %PAM
gap_linear_pam = (argQ_pam.^2)/3;
gap_db_pam = 10*log10(gap_linear_pam);

