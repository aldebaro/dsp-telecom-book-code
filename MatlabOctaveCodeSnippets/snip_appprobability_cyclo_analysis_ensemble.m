snip_appprobability_modulatednoise %generate modulated WGN
alphaFFTLength=3*P; %P is the period, a multiple of P avoids leakage
[Cxx,alphas,lags] = ak_cyclicCorrelationEnsemble(X, alphaFFTLength); 
onlyPositiveCycles=1; exclude0Alpha=1; %take only alpha>0 in account
[peakValue,peakAlpha,peakLag] = ak_peakOfCyclicCorrelation(Cxx, ...
    alphas,lags,exclude0Alpha,onlyPositiveCycles); %get the peak
WEstimated=peakAlpha/2; %estimated frequency in rad
phaseEstimated = angle(peakValue)/2; %phase in rad
phaseOffset=wrapToPi(Phc) - wrapToPi(phaseEstimated); %force [-pi,pi]
periodEstimated=round(2*pi/WEstimated); %estimate period (samples)
disp(['Peak value=' num2str(abs(peakValue)) '*exp(' ...
    num2str(angle(peakValue)) 'j)'])
disp(['Period:  Correct=' num2str(P) ', Estimated=' ...
    num2str(periodEstimated) ' (samples)'])
disp(['Cycle:  Correct=' num2str(Wc) ', Estimated=' ...
    num2str(WEstimated) '(rad). Error=' num2str(Wc-WEstimated)])
disp(['Phase:  Correct=' num2str(Phc) ', Estimated=' ...
    num2str(phaseEstimated) '(rad). Error=' num2str(phaseOffset)])

%% Plot graphs
Cmag=abs(Cxx);
if 0 %want to clean up phase
    smallMagIndices = find(Cmag<max(Cmag(:))/1e2);
    Sphase(smallMagIndices)=0;
end

%imagesc(alpha,f,abs(S(1:nfft/2,:))),axis xy
mesh(lags,alphas,Cmag);
xlabel('lag l'); ylabel('cycle \alpha'); zlabel('|Cx|')
hold on
plot(peakLag,peakAlpha,'or','MarkerSize',15);
hold off

if abs(phaseOffset)>0.1 %error is typically multiple of pi
    disp(['Phase offset dividided by pi = ' num2str(phaseOffset/pi)])
end