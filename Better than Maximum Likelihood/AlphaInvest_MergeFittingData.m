
clc;
clearvars;
TotalDataFileName='Data\AlphaInvest_Data.mat';
SubjectNums=1000;
RunIndex=1:20;
RunNum=length(RunIndex);
SetNum=21;

%                   W   Alpha1  Alpha2  Beta1	Beta2	Lambda  P1  P2
ParamsIndex      = [1   1       0       1       0       0       0   0   %Daw3ParamV1
                    1   1       0       1       0       0       0   0   %Daw3ParamV2
                    1   1       0       1       0       1       0   0   %Daw4Param
                    1   1       1       1       1       0       0   0   %Daw5ParamV1
                    1   1       1       1       1       0       0   0   %Daw5ParamV2
                    1   1       1       1       1       1       0   0   %Daw6Param
                    1   1       1       1       1       1       1   0   %Daw7ParamV1
                    1   1       1       1       1       1       1   0   %Daw7ParamV2
                    1   1       1       1       1       1       1   1]; %Daw8Param

ParamNum=(sum(ParamsIndex,2))';

TotalSubjectNums=SubjectNums*RunNum;
FittedW     = zeros(TotalSubjectNums,18,SetNum);
AgentW      = zeros(TotalSubjectNums,SetNum);
BestFittedW = zeros(TotalSubjectNums,2);
NR=zeros(SubjectNums,1);
tic
k=0;
for R=RunIndex
    for P=1:SetNum
        fprintf('|Run %d |Part %d|\n',R,P)
        DataFileName=['Data\AlphaInvest_FittingData_Part',num2str(P),'Run',num2str(R),'_BC.mat'];
        Data=load(DataFileName);
        for s=1:SubjectNums
        for i=1:9:18
            [~,I]=min(2*ParamNum+2*Data.FittedNegLogLik(s,i:i+8));
            I=I+i-1;
            BestFittedW    (k+s,ceil(i/9) , P) = Data.FittedParams(s,1,I);
        end
        FittedW  (k+s,:,P) = Data.FittedParams(s,1,:);
        AgentW   (k+s  ,P) = Data.Params(s,1);
        end
    end
    k=k+SubjectNums;
end
AlphaSet=Data.AlphaSet;
save(TotalDataFileName,'AgentW','FittedW','BestFittedW','AlphaSet')
toc