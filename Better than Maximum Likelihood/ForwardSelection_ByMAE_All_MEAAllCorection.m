% Feature Selection By Forward Selection
clc;
clearvars;
rng('shuffle');
K=100;
DataFileName=['Data\FrwdSelectData_ByMAE_FitExc_',num2str(K),'NN.mat'];
load(DataFileName)
% save(DataFileName,'Features','BestMAE','AnalizeErorrs','MAEALL','FNum','MaxFNum','EliminatedFeatures','FeaturesName')
FoldNumber=5;
[Train,Test]=GetKFoldRegressorDataFromRepository(FoldNumber,true);
Train.Features(:,EliminatedFeatures,:)=[];
Train.FeaturesName(EliminatedFeatures)=[];
Test.Features(:,EliminatedFeatures,:)=[];
Test.FeaturesName(EliminatedFeatures)=[];

Erorrs=zeros(FoldNumber,Test.SNum);
%% All Features MAE 
for f=1:FoldNumber
    display(f)
KNNRegressor = KNNReg(Train.Features(:,:,f),Train.Label(:,f),'NumNeighbors',K,'RegresiorMethod','InverseDistance');
PredictedValue=GetRegValue(KNNRegressor,Test.Features(:,:,f));
Erorrs(f,:)=PredictedValue-Test.Label(:,f);
end
MAEALL=mean2(abs(Erorrs));
%
save(DataFileName,'Features','BestMAE','AnalizeErorrs','MAEALL','FNum','MaxFNum','EliminatedFeatures','FeaturesName')