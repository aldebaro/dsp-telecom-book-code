Ec = mean(abs(const).^2)
Eh = sum(htx.^2)
Px = Ec/L
powerTxComplexEnvelope = Px * Eh
powerTxSignal = powerTxComplexEnvelope/2

