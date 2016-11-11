%define s, z, natural frequency, damping ratio and sampling interval
syms s z wn zeta Ts %all as symbolic variables
Hs=wn^2/(s^2+2*zeta*wn*s+wn^2) %H(s). Use pretty(Hs) to see it
%Hs=(2*zeta*wn*s+wn^2)/(s^2+2*zeta*wn*s+wn^2) %Another H(s)
Hz=subs(Hs,s,(2/Ts)*((z-1)/(z+1))) %bilinear: s <- 2/Ts*(z-1)/(z+1)
Hz=simplify(Hz) %simplify the expression 
pretty(Hz) %show it using an alternative view
