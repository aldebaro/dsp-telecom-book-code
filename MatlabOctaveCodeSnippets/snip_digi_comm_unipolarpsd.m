function [psdNoImpulse,f1,psdImpulseParcel,f2] = ...
    snip_digi_comm_unipolarpsd(Rsym,A,B,M,maxFreq)
%function [psdNoImpulse,f1,psdImpulseParcel,f2] = ...
%    snip_digi_comm_unipolarpsd(Rsym,A,B,M,maxFreq)
%Theoretical expression for unipolar RZ line code
%Rsym is the baud rate, number of symbols (bits in this case) per sec
%A => amplitude of the shaping pulse
%B => binary constellation has symbols with values 0 and B
%M => Tsym/M is the support of the shaping pulse
Tsym=1/Rsym; %symbol period
constantFactor=A^2*B^2/(4*M^2); %theoretical expression parcel
f1=linspace(-maxFreq,maxFreq,4096); %a good resolution grid frequency 
psdNoImpulse=constantFactor*Tsym*sinc(f1*Tsym/M).^2;
%generate the impulses areas and their frequencies (vector f2)
maxMultiple=ceil(maxFreq/Rsym); %maximum multiple of Rsym of interest
f2=[]; %will grow inside loop
for i=1:maxMultiple
    if i/M ~= round(i/M) %if impulse does not coincide with sinc null
        f2 = [f2 i]; %add this specific multiple of Rsym
    end
end
f2 = Rsym*[-fliplr(f2) 0 f2]; %add negative frequencies and DC, scale
psdImpulseParcel=constantFactor*sinc(f2*Tsym/M).^2; %impulses areas

curve = constantFactor*Tsym*sinc(f2*Tsym/M).^2;
ak_impulseplotOnCurve(f2,curve,psdImpulseParcel,'EdgeColor','b','FaceColor','b')

if nargout ~= 0 %plot both parcels in linear scale
    plot(f1,psdNoImpulse), hold on
    temp = constantFactor*Tsym*sinc(f2*Tsym/M).^2;
    for i=1:length(psdImpulseParcel)
        %arrowline([1 2],[3 4])
        %arrowline([f2(i) f2(i)],[temp(i) psdImpulseParcel(i)])
        arrow([f2(i) temp(i)],[f2(i) temp(i)+psdImpulseParcel(i)],...
            'EdgeColor','b','FaceColor','b')
        %text(f2(i),temp(i),'\uparrow','fontsize',20,'color','blue')
        %text(f2(i),temp(i),'^','fontsize',20,'color','blue')
    end
    myaxis = axis;
    clf
    plot(f1,psdNoImpulse), hold on
    axis(myaxis);
    temp = constantFactor*Tsym*sinc(f2*Tsym/M).^2;
    for i=1:length(psdImpulseParcel)
        %arrowline([1 2],[3 4])
        %arrowline([f2(i) f2(i)],[temp(i) psdImpulseParcel(i)])
        arrow([f2(i) temp(i)],[f2(i) temp(i)+psdImpulseParcel(i)],...
            'EdgeColor','b','FaceColor','b')
        %text(f2(i),temp(i),'\uparrow','fontsize',20,'color','blue')
        %text(f2(i),temp(i),'^','fontsize',20,'color','blue')
    end
    
    %ak_impulseplot(psdImpulseParcel,f2,[]) %assumes abscissa in sec.
    %axis([-800.0000  800.0000   -0.0020    0.0160]);
    xlabel('frequency (Hz)'), ylabel('PSD (dBW / Hz)')
end
