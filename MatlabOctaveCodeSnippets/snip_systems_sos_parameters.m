zeta=0.5 %damping ratio, e.g. sqrt(2)/2 = 0.707;
wn=2 %natural frequency in rad/s
epsilon=0.05 %tolerance for the settling time (5% in this case)
tp_factor=pi/sqrt(1-zeta^2) %depends on zeta only
tp=tp_factor/wn %peak time
tr_factor=(2.23*zeta^2 - 0.078*zeta + 1.12)/sqrt(1-zeta^2) %zeta only
tr=tr_factor/wn %rise time
ts_factor= -log(epsilon * sqrt(1-zeta^2))/(zeta) %zeta only
ts=ts_factor/wn %settling time
ov=exp(-(zeta*pi)/sqrt(1-zeta^2)) %overshoot (depends on zeta only)
bw_factor=sqrt(1-2*zeta^2 + sqrt(2 - 4*zeta^2 + 4*zeta^4)) %zeta only
bw_r=wn*bw_factor %bandwidth in radians/second