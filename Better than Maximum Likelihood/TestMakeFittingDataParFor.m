 % Make Test Data Different Noise Ratio
clc;
clearvars;
NoiseRatio=[0,0.01,0.02,0.04,0.06,0.08,0.1,0.15,0.2,0.3,0.4,0.5];
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
StartNum=5;
MaxStep=200;

Runs=105:108;

RunNum=length(Runs);


RunParams=cell(RunNum,1);
RunObserverRngState=cell(RunNum,1);
RunBestFittedParams=cell(RunNum,1);
RunBestFittedNegLogLikelihood=cell(RunNum,1);

for Part=1:12
ThisPartNoiseRatio=NoiseRatio(Part);
parfor Run=1:RunNum
tic
rng('shuffle');
warning off
fprintf('Make Observation\n')
W=rand(SubjectNums,1);
Alpha1=betarnd(1.2,1.2,SubjectNums,1);
Alpha2=betarnd(1.2,1.2,SubjectNums,1);
Beta1=1+9*betarnd(1.2,1.2,SubjectNums,1);
Beta2=1+9*betarnd(1.2,1.2,SubjectNums,1);
Lambda=betarnd(1.2,1.2,SubjectNums,1);
P1=0.2*rand(SubjectNums,1);
P2=0.2*rand(SubjectNums,1);
NR=ThisPartNoiseRatio*ones(SubjectNums,1);
Params=[W,Alpha1,Alpha2,Beta1,Beta2,Lambda,P1,P2];
ObserverRngState=rng();
[ObserveMat]= ParallDawReinforcmenLearningAgents([Params,NR],'Daw8Param');

fprintf('Fitting Observation\n')

BestFittedParams=zeros(SubjectNums,8,MethodesNum*2);
BestFittedNegLogLikelihood=zeros(SubjectNums,MethodesNum*2);
Sofar=0;
Total=SubjectNums*2*MethodesNum;
for M=1:MethodesNum
    ParamNum=sum(ParamsIndex(M,:));
    TempFittingParams=FittingParams;
    TempFittingParams.Low(ParamsIndex(M,:)==0)=[];
    TempFittingParams.High(ParamsIndex(M,:)==0)=[];
    [BestFittedParams(:,1:ParamNum,M            ),BestFittedNegLogLikelihood(:,M            )]=DawInteriorPointFitting(ObserveMat,TempFittingParams,Methodes{M},'MLE',StartNum,MaxStep,[num2str(Runs(Run)),'-',num2str(Part),')',Methodes{M},'|MLE|'],Sofar,Total); %#ok<*PFBNS>
    Sofar=Sofar+SubjectNums;
    [BestFittedParams(:,1:ParamNum,M+MethodesNum),BestFittedNegLogLikelihood(:,M+MethodesNum)]=DawInteriorPointFitting(ObserveMat,TempFittingParams,Methodes{M},'MAP',StartNum,MaxStep,[num2str(Runs(Run)),'-',num2str(Part),')',Methodes{M},'|MAP|'],Sofar,Total);
    Sofar=Sofar+SubjectNums;
end
RunParams{Run}=Params;
RunObserverRngState{Run}=ObserverRngState;
RunBestFittedParams{Run}=BestFittedParams;
RunBestFittedNegLogLikelihood{Run}=BestFittedNegLogLikelihood;
end
fprintf('Save Data\n')
for Run =1:RunNum
TotalDataFileName=['Data\Test_FittingData_Part',num2str(Part),'Run',num2str(Runs(Run)),'.mat'];
Params=RunParams{Run};
ObserverRngState=RunObserverRngState{Run};
BestFittedParams=RunBestFittedParams{Run};
BestFittedNegLogLikelihood=RunBestFittedNegLogLikelihood{Run};
save(TotalDataFileName,'Params','ObserverRngState','BestFittedParams','BestFittedNegLogLikelihood','Methodes','ThisPartNoiseRatio')
end
end