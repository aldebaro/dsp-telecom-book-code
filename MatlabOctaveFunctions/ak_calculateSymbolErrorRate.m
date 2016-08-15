function ser=ak_calculateSymbolErrorRate(symIndicesTx,symIndicesRx)
% function ser=ak_calculateSymbolErrorRate(symIndicesTx,symIndicesRx)
%Get percentage of wrong symbols (sym) by comparing two sequences:
numErrors=sum(symIndicesTx ~= symIndicesRx); %number of errors
N=length(symIndicesTx); %N is the number of symbols
ser = numErrors / N; %estimated probability of an error