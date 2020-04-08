% 
clc;
clearvars;
TotalDataFileName='Data\VersionInvest_Data.mat';
SubjectNums=1000;
RunNum=4;
MethodesNum=9;
TotalSubjectNums=SubjectNums*RunNum;
MLEFittedW     = zeros(TotalSubjectNums,MethodesNum,MethodesNum);
MAPFittedW     = zeros(TotalSubjectNums,MethodesNum,MethodesNum);
MLEFittedNLL   = zeros(TotalSubjectNums,MethodesNum,MethodesNum);
MAPFittedNLL   = zeros(TotalSubjectNums,MethodesNum,MethodesNum);
AgentW         = zeros(TotalSubjectNums,MethodesNum);

k=0;
tic
for R=1:RunNum
    for P=1:MethodesNum
        fprintf('|Run %d |Part %d|\n',R,P)
        DataFileName=['Data\VersionInvest_FittingData_Part',num2str(P),'Run',num2str(R),'.mat'];
        Data=load(DataFileName);
        AgentW((k+1):(k+SubjectNums),P) = Data.Params(:,1);
        for i=1:MethodesNum
            MLEFittedW   ((k+1):(k+SubjectNums),P,i)=Data.BestFittedParams(:,1,i);
            MAPFittedW   ((k+1):(k+SubjectNums),P,i)=Data.BestFittedParams(:,1,i+MethodesNum);
            MLEFittedNLL ((k+1):(k+SubjectNums),P,i)=Data.BestFittedNegLogLikelihood(:,i);
            MAPFittedNLL ((k+1):(k+SubjectNums),P,i)=Data.BestFittedNegLogLikelihood(:,i+MethodesNum);
        end
    end
    k=k+SubjectNums;
end
toc
Methodes=Data.Methodes;
save(TotalDataFileName,'AgentW','MLEFittedW','MAPFittedW','MLEFittedNLL','MAPFittedNLL','Methodes')