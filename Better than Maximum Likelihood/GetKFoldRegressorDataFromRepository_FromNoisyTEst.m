
function [Train,Test,AllData]=GetKFoldRegressorDataFromRepository_FromNoisyTEst(KF,AddFullyAgent)
if nargin<2
    AddFullyAgent=false;
end
AllData=load('Data\TrainDataset.mat');
MaxSNum=80000;

AllData.BestFittedW(MaxSNum+1:end,:)=[];
AllData.Features(MaxSNum+1:end,:)=[];
AllData.FittedW(MaxSNum+1:end,:)=[];
AllData.Label(MaxSNum+1:end,:)=[];

AllData.SNum=size(AllData.Features,1);
AllData.FNum=size(AllData.Features,2);
AllData.FittedWNum=size(AllData.FittedW,2);

TestData=load('Data\TestDataset.mat');
TSTN = 1200;
TRNN = AllData.SNum;
Index=randperm(AllData.SNum);

Test.SetNum = KF;
Test.SNum   = TSTN;
Test.FeaturesName   = AllData.FeaturesName;
Test.FittedW        = zeros(TSTN,AllData.FittedWNum ,KF);
Test.Label          = zeros(TSTN,KF);
Test.Features       = zeros(TSTN,AllData.FNum,KF);

Train.SetNum = KF;
if AddFullyAgent
    MBAllData=load('Data/TrainDataset_PureMB.mat');
    MBSNum=20000;
    MBAllData.Features(MBSNum+1:end,:)=[];
    MBAllData.FittedW(MBSNum+1:end,:)=[];
    MBAllData.Label(MBSNum+1:end,:)=[];
    MBSNum=size(MBAllData.Features,1);
    
    MFAllData=load('Data/TrainDataset_PureMF.mat');
    MFSNum=20000;
    MFAllData.Features(MFSNum+1:end,:)=[];
    MFAllData.FittedW(MFSNum+1:end,:)=[];
    MFAllData.Label(MFSNum+1:end,:)=[];
    MFSNum=size(MFAllData.Features,1);
    
    Train.SNum   = TRNN + MBSNum + MFSNum;
else
    Train.SNum   = TRNN;
end
Train.FeaturesName   = AllData.FeaturesName;
Train.FittedW        = zeros(Train.SNum,AllData.FittedWNum,KF);
Train.Label          = zeros(Train.SNum,KF);
Train.Features       = zeros(Train.SNum,AllData.FNum,KF);

for k=1:KF
    TestIndex  = Index( 1 + (k-1)*TSTN : k * TSTN);
    TrainIndex = Index([1 : (k-1)*TSTN ,(k * TSTN +1) : AllData.SNum]);
    
    Test.Features(:,:,k)       = TestData.Features(1 + (k-1)*TSTN : k * TSTN,:,1);
    Test.Label(:,k)            = TestData.Label(1 + (k-1)*TSTN : k * TSTN,1);
    Test.FittedW(:,:,k)        = TestData.FittedW(1 + (k-1)*TSTN : k * TSTN,:,1);
    
    Train.Features(1:TRNN,:,k)      = AllData.Features;
    Train.Label(1:TRNN,k)           = AllData.Label;
    Train.FittedW(1:TRNN,:,k)       = AllData.FittedW;
end


if AddFullyAgent
    Train.Features   (TRNN+1:TRNN+MBSNum,:,:) = repmat(MBAllData.Features,1,1,KF);
    Train.Label      (TRNN+1:TRNN+MBSNum,  :) = repmat(MBAllData.Label,1,KF);
    Train.FittedW    (TRNN+1:TRNN+MBSNum,:,:) = repmat(MBAllData.FittedW,1,1,KF);
    
    Train.Features   (TRNN+MBSNum+1:end,:,:)  = repmat(MFAllData.Features,1,1,KF);
    Train.Label      (TRNN+MBSNum+1:end,  :)  = repmat(MFAllData.Label,1,KF);
    Train.FittedW    (TRNN+MBSNum+1:end,:,:)  = repmat(MFAllData.FittedW,1,1,KF);
    
    % permute subject to combine MB and MF 
    Index=randperm(Train.SNum,Train.SNum);
    Train.Features(Index,:,:) = Train.Features;
    Train.Label   (Index,  :) = Train.Label;
    Train.FittedW (Index,:,:) = Train.FittedW;
end

FittingMethods={'MLE','MAP'};
Test.Methodes     = {};
for i=1:length(FittingMethods)
    for j=1:length(AllData.Methodes)
        Test.Methodes= [Test.Methodes,{[FittingMethods{i},' ',AllData.Methodes{j}]}];
    end
end
Train.Methodes=Test.Methodes;