% Make Data for analyze the effect of Beta variation on fitting 
clc;
clearvars;
BetaSet=1:1:10;
BetaNum=length(BetaSet);
rng('shuffle');
Methodes = {'Daw3ParamV1','Daw3ParamV2','Daw4Param','Daw5ParamV1','Daw5ParamV2','Daw6Param','Daw7ParamV1','Daw7ParamV2','Daw8Param'};
MethodesNum=length(Methodes);
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
%                   W   Alpha1  Alpha2  Beta1	Beta2	Lambda  P1  P2
FittingParams.Low =[0   0       0       1       1       0       0   0];
FittingParams.High=[1   1       1       10      10      1       1   1];
FittingOption.StartNum=5;
FittingOption.MaxStep=100;

SubjectNums=1000;
RunInd=13:20;
for Part=1:BetaNum
tic
parfor Run=RunInd  
tic
fprintf('Make Observation\n')
W=rand(SubjectNums,1);
Alpha=betarnd(1.2,1.2,SubjectNums,1);
Beta=BetaSet(Part)*ones(SubjectNums,1);  %#ok<*PFBNS>
NR=0*ones(SubjectNums,1);
Params=[W,Alpha,Beta];
ObserverRngState=rng();
[ObserveMat]= ParallDawReinforcmenLearningAgents([Params,NR],'Daw3ParamV1');

fprintf('Fitting Observation\n')

FittedParams=zeros(SubjectNums,8,MethodesNum*2);
FittedNegLogLik=zeros(SubjectNums,MethodesNum*2);

Step=FittingOption.MaxStep;
Sofar=0;
Total=Step*2*MethodesNum;
for M=1:MethodesNum
    ParamNum=sum(ParamsIndex(M,:));
    TempFittingParams=FittingParams;
    TempFittingParams.Low(ParamsIndex(M,:)==0)=[];
    TempFittingParams.High(ParamsIndex(M,:)==0)=[];
    [FittedParams(:,1:ParamNum,M            ),FittedNegLogLik(:,M            )]=DawInteriorPointFitting(ObserveMat,TempFittingParams,Methodes{M},'MLE' ,FittingOption.StartNum,FittingOption.MaxStep,[num2str(Run),'-',num2str(Part),')',Methodes{M},'|MLE|'],Sofar,Total);
    Sofar=Sofar+Step;
    [FittedParams(:,1:ParamNum,M+MethodesNum),FittedNegLogLik(:,M+MethodesNum)]=DawInteriorPointFitting(ObserveMat,TempFittingParams,Methodes{M},'MAP' ,FittingOption.StartNum,FittingOption.MaxStep,[num2str(Run),'-',num2str(Part),')',Methodes{M},'|MAP|'],Sofar,Total);
    Sofar=Sofar+Step;
end

RunParams{Run}=Params;
RunObserverRngState{Run}=ObserverRngState;
RunFittedParams{Run}=FittedParams;
RunFittedNegLogLik{Run}=FittedNegLogLik;
end

fprintf('Save Data\n')
for Run =RunInd
DataFileName=['Data\BetaInvest_FittingData_Part',num2str(Part),'Run',num2str(Run),'_BC.mat'];
Params=RunParams{Run};
ObserverRngState=RunObserverRngState{Run};
FittedParams=RunFittedParams{Run};
FittedNegLogLik=RunFittedNegLogLik{Run};
save(DataFileName,'Params','ObserverRngState','FittedParams','FittedNegLogLik','BetaSet','Part')
end
end