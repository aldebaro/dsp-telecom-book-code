function [Hz,X,Y]=ak_bilinearPlotZPlane(Hs_num,Hs_den,...
    Fs,zlim)
% function [Hz,X,Y]=ak_bilinearPlotZPlane(Hs_num, Hs_den,
%   Fs, zlim)
%Converts the input H(s)=Hs_num/Hs_den into H(z) using the
%bilinear transform. Fs is the sampling frequency in Hz
%and zlim defines the grid in the z plane for evaluating
%H(s): [-zlim zlim -zlim zlim].
[X,Y]=meshgrid(linspace(-zlim,zlim,100)); %100x100 grid
z=X+j*Y; %matrix with all points of interest in z plane
if 1 %1st method: convert H(s) to H(z) using bilinear
    [Hz_num, Hz_den]=bilinear(Hs_num, Hs_den, Fs);
    Hz=polyval(Hz_num,z)./polyval(Hz_den,z);
else %2nd met.: for each z find corresponding s, then H(s)
    s=(2*Fs*(z-1))./(z+1); %use bilinear transformation
    %Use H(z)=H(s)|s=2Fs(z-1)/(z+1)
    Hz=polyval(Hs_num,s)./polyval(Hs_den,s); %H(z)
end
if nargout == 0
    meshc(X,Y,20*log10(abs(Hz))); %plot in dB
    xlabel('Re\{z\}'); ylabel('Im\{z\}'); 
    zlabel('20 log_{10} |H(z)|');
end