% Make Data Different Version of Agent Model
clc;
clearvars;
SubjectNums=1000;
Methodes = {'Daw3ParamV1','Daw3ParamV2','Daw4Param','Daw5ParamV1','Daw5ParamV2','Daw6Param','Daw7ParamV1','Daw7ParamV2','Daw8Param'};
MethodesNum = length(Methodes);
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

Step=FittingOption.MaxStep;
Total=FittingOption.MaxStep*MethodesNum*2;

OldRun=0;
RunNum=4;
RunParams=cell(RunNum,1);
RunObserverRngState=cell(RunNum,1);
RunBestFittedParams=cell(RunNum,1);
RunBestFittedNegLogLikelihood=cell(RunNum,1);
for Part=1:MethodesNum
parfor Run=1:RunNum
Sofar=0;
tic
BestFittedParams=zeros(SubjectNums,8,MethodesNum*2);
BestFittedNegLogLikelihood=zeros(SubjectNums,MethodesNum*2);
rng('shuffle');

fprintf('Run %d ) Make Observation\n',Run)
W=rand(SubjectNums,1);
Alpha1=betarnd(1.2,1.2,SubjectNums,1);
Alpha2=betarnd(1.2,1.2,SubjectNums,1);
Beta1 = 1+9*betarnd(1.2,1.2,SubjectNums,1);
Beta2 = 1+9*betarnd(1.2,1.2,SubjectNums,1);
Lambda = betarnd(1.2,1.2,SubjectNums,1);
P1=0.2*rand(SubjectNums,1);
P2=0.2*rand(SubjectNums,1);
NR=zeros(SubjectNums,1);
switch Methodes{Part}
    case {'Daw3ParamV1','Daw3ParamV2'}
        Params=[W,Alpha1,Beta1];
    case 'Daw4Param'
        Params=[W,Alpha1,Beta1,Lambda];
    case {'Daw5ParamV1','Daw5ParamV2'}
        Params=[W,Alpha1,Alpha2,Beta1,Beta2];
    case 'Daw6Param'
        Params=[W,Alpha1,Alpha2,Beta1,Beta2,Lambda];
    case {'Daw7ParamV1','Daw7ParamV2'}
        Params=[W,Alpha1,Alpha2,Beta1,Beta2,Lambda,P1];
    case 'Daw8Param'
        Params=[W,Alpha1,Alpha2,Beta1,Beta2,Lambda,P1,P2];
end
ObserverRngState=rng();
[ObserveMat]= ParallDawReinforcmenLearningAgents([Params,NR],Methodes{Part});

fprintf('Fitting Observation\n')
for M=1:MethodesNum
    ParamNum=sum(ParamsIndex(M,:)); %#ok<*PFBNS>
    TempFittingParams=FittingParams;
    TempFittingParams.Low(ParamsIndex(M,:)==0)=[];
    TempFittingParams.High(ParamsIndex(M,:)==0)=[];
    [BestFittedParams(:,1:ParamNum,M            ),BestFittedNegLogLikelihood(:,M            )]=DawInteriorPointFitting(ObserveMat,TempFittingParams,Methodes{M},'MLE',FittingOption.StartNum,FittingOption.MaxStep,[num2str(Run),'-',num2str(Part),')',Methodes{M},'|MLE|'],Sofar,Total);
    Sofar=Sofar+1;
    [BestFittedParams(:,1:ParamNum,M+MethodesNum),BestFittedNegLogLikelihood(:,M+MethodesNum)]=DawInteriorPointFitting(ObserveMat,TempFittingParams,Methodes{M},'MAP',FittingOption.StartNum,FittingOption.MaxStep,[num2str(Run),'-',num2str(Part),')',Methodes{M},'|MAP|'],Sofar,Total);
    Sofar=Sofar+1;
end
RunParams{Run}=Params;
RunObserverRngState{Run}=ObserverRngState;
RunBestFittedParams{Run}=BestFittedParams;
RunBestFittedNegLogLikelihood{Run}=BestFittedNegLogLikelihood;
end

fprintf('Save Data\n')
for Run =1:RunNum
TotalDataFileName=['Data\VersionInvest_FittingData_Part',num2str(Part),'Run',num2str(Run+OldRun),'.mat'];
Params=RunParams{Run};
ObserverRngState=RunObserverRngState{Run};
BestFittedParams=RunBestFittedParams{Run};
BestFittedNegLogLikelihood=RunBestFittedNegLogLikelihood{Run};
save(TotalDataFileName,'Params','ObserverRngState','BestFittedParams','BestFittedNegLogLikelihood','Methodes')
end
end