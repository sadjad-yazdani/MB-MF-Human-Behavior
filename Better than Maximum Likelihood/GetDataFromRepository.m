
function [Train,Test]=GetDataFromRepository(AddFullyAgent,TestNoiseIndex)
if nargin<1
    AddFullyAgent=false;
    TestNoiseIndex=1;
elseif nargin<2
    TestNoiseIndex=1;
end

Train=load('Data/TrainDataset.mat');

MaxSNum=80000;
Train.BestFittedW(MaxSNum+1:end,:)=[];
Train.Features(MaxSNum+1:end,:)=[];
Train.FittedW(MaxSNum+1:end,:)=[];
Train.Label(MaxSNum+1:end,:)=[];
% [Train.PCAFeatures,PCAMat,Mu,R]=PCA_FC(Train.Features);

if AddFullyAgent
    MBAllData=load('Data/TrainDataset_PureMB.mat');
    MBSNum=20000;
    MBAllData.Features(MBSNum+1:end,:)=[];
    MBAllData.FittedW(MBSNum+1:end,:)=[];
    MBAllData.BestFittedW(MBSNum+1:end,:)=[];
    MBAllData.Label(MBSNum+1:end,:)=[];
%     MBAllData.PCAFeatures=GetPCAValue(MBAllData.Features,PCAMat,Mu,R);

    MFAllData=load('Data/TrainDataset_PureMF.mat');
    MFSNum=20000;
    MFAllData.Features(MFSNum+1:end,:)=[];
    MFAllData.FittedW(MFSNum+1:end,:)=[];
    MFAllData.BestFittedW(MFSNum+1:end,:)=[];
    MFAllData.Label(MFSNum+1:end,:)=[];
%     MFAllData.PCAFeatures=GetPCAValue(MFAllData.Features,PCAMat,Mu,R);

    Train.Features    = [Train.Features   ;MBAllData.Features   ;MFAllData.Features];
%     Train.PCAFeatures = [Train.PCAFeatures;MBAllData.PCAFeatures;MFAllData.PCAFeatures];
    Train.Label       = [Train.Label      ;MBAllData.Label      ;MFAllData.Label];
    Train.FittedW     = [Train.FittedW    ;MBAllData.FittedW    ;MFAllData.FittedW];
    Train.BestFittedW = [Train.BestFittedW;MBAllData.BestFittedW;MFAllData.BestFittedW];
end
Train.SNum=size(Train.Features,1);
Index=randperm(Train.SNum);
Train.Features=Train.Features(Index,:);
Train.Label=Train.Label(Index,:);
Train.FittedW=Train.FittedW(Index,:);
Train.BestFittedW=Train.BestFittedW(Index,:);

TestData=load('Data/TestDataset.mat');

Test.SNum=min(size(TestData.Features,1),30000);
TestNoiseIndex=min(max(TestNoiseIndex,1),size(TestData.Features,3));

Test.FeaturesName   = TestData.FeaturesName;
Test.Features       = TestData.Features(1:Test.SNum,:,TestNoiseIndex);
Test.Label          = TestData.Label(1:Test.SNum,TestNoiseIndex);
Test.FittedW        = TestData.FittedW(1:Test.SNum,:,TestNoiseIndex);
Test.BestFittedW    = TestData.BestFittedW(1:Test.SNum,:,TestNoiseIndex);
Test.NoiseRatio     = TestData.NoiseRatio(TestNoiseIndex);
