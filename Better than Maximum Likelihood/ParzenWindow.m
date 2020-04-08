% Parzen Estimation of P(x) based on X data
function [p,pv]=ParzenWindow(X,h)
% h=0.1;
% X=rand(3000,2);

N=size(X,1);
Steps=0:h:1;
Steps(1)=-1e-10; %for exact zero values
Steps(end)=1+1e-10; %for exact one values
StepNum=length(Steps)-1;
p=zeros(StepNum);
NX1=zeros(StepNum);
for i=1:StepNum
for j=1:StepNum
    p(i,j)=nnz(X(:,1)>Steps(i)&X(:,1)<=Steps(i+1)&X(:,2)>Steps(j)&X(:,2)<=Steps(j+1));
end
NX1(i,:)=nnz(X(:,1)>Steps(i)&X(:,1)<=Steps(i+1));
end
p=p./NX1;

p(isnan(p))=0;

pv=zeros(N,1);
for i=1:N
    pv(i)=p(X(i,1)>Steps(1:end-1)&X(i,1)<=Steps(2:end),X(i,2)>Steps(1:end-1)&X(i,2)<=Steps(2:end));
end
