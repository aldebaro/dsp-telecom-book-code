function figs_app_plot_qvalues
% show Q values
clf
onePlot(-10, 0, 1, 0);
title('Very low SNR Q-function values');
writeEPS('qfunc_verylowsnr');

onePlot(0, 10, 1, 1);
title('Low SNR Q-function values');
writeEPS('qfunc_lowsnr');

onePlot(10, 20, 1, 1);
title('High SNR Q-function values');
writeEPS('qfunc_highsnr');
end %end main function

%auxiliary function
function onePlot(db_min, db_max, fig_number, uselog)
N=100;
xdb = linspace(db_min, db_max, N); %in dB
x=10.^(xdb/20); %convert to linear scale
y = 0.5*erfc(x/sqrt(2)); %calculate Q using erfc
figure(fig_number)
if uselog==1
    semilogy(xdb,y);
else
    plot(xdb,y);
end
xlabel('x in dB, that is, 20 log10(x)'); ylabel('Q(x)');
grid
end