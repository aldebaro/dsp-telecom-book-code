%generate simple PAM constellation (no Gray coding)
close all
clear all
M = 8; %number of symbols
largestAmplitude = M-1; %considering ..., -3,-1,1,3,5,7,...
alphabet=[-largestAmplitude:2:largestAmplitude]; %possible symbols

% Plot the constellation.
%scatterplot(alphabet) %,1,0,'b.'); % Dots for points.
plot(alphabet, zeros(size(alphabet)), 'xb','markersize',12);
% Include text annotations that number the points in binary.
hold on; % Make sure the annotations go in the same figure.
annot = dec2bin([0:length(alphabet)-1],log2(M));
text(real(alphabet)-0.4,imag(alphabet)+0.4,annot);
axis image
axis([-(largestAmplitude+1) (largestAmplitude+1) -1 1]);
%title('Constellation for 8-PAM');
xlabel('Symbols m')
hold off;
writeEPS('constellation8pam');
%close all

clf
%generate PAM constellation with Gray coding
alphabet = real(pammod(0:M-1,M,0,'gray')); % Modulate.
% Plot the constellation.
%scatterplot(alphabet) %,1,0,'b.'); % Dots for points.
plot(alphabet, zeros(size(alphabet)), 'xb','markersize',12);
% Include text annotations that number the points in binary.
hold on; % Make sure the annotations go in the same figure.
annot = dec2bin([0:length(alphabet)-1],log2(M));
text(real(alphabet)-0.4,imag(alphabet)+0.4,annot);
axis image
axis([-(largestAmplitude+1) (largestAmplitude+1) -1 1]);
%title('Constellation for Gray-Coded 8-PAM');
xlabel('Symbols m')

writeEPS('constellation8pamgray');