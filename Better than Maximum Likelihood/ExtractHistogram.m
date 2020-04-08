function [Freq,Hist]=ExtractHistogram(X,Bins,Flag)
if nargin<3
    Flag=true(1,size(X,1));
end
A=X(Flag,:);
if nargin<2
    Bins=unique(A(:));
end
Hist=hist(A(:),Bins);
Freq=Hist/sum(Hist);