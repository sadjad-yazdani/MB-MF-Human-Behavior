
function [Train,Test]=GetNoisyDataFromRepository(AddFullyAgent)
if nargin<1
    AddFullyAgent=false;
end

TrainData=load('Data/TrainDataset.mat');

SNum=50000;
TrainData.Features(SNum+1:end,:)=[];
TrainData.Label(SNum+1:end,:)=[];

if AddFullyAgent
    MBAllData=load('Data/TrainDataset_PureMB.mat');
    MBSNum=8000;
    MBAllData.Features(MBSNum+1:end,:)=[];
    MBAllData.Label(MBSNum+1:end,:)=[];
    
    MFAllData=load('Data/TrainDataset_PureMF.mat');
    MFSNum=8000;
    MFAllData.Features(MFSNum+1:end,:)=[];
    MFAllData.Label(MFSNum+1:end,:)=[];
    
    TrainData.Features = [TrainData.Features   ;MBAllData.Features     ;MFAllData.Features];
    TrainData.Label    = [TrainData.Label      ;MBAllData.Label        ;MFAllData.Label ];

% permute subject to combine MB and MF 
    TrainData.SNum=SNum+MBSNum+MFSNum;
    Index=randperm(TrainData.SNum,TrainData.SNum);
    TrainData.Features(Index,:,:) = TrainData.Features;
    TrainData.Label   (Index,  :) = TrainData.Label;
end

Train.SNum          = size(TrainData.Features,1);
Train.FeaturesName  = TrainData.FeaturesName;
Train.Label         = TrainData.Label;
Train.Features      = TrainData.Features;

TestData=load('Data/TestDataset.mat');
SNum=30000;
TestData.BestFittedW(SNum+1:end,:,:)=[];
TestData.Features(SNum+1:end,:,:)=[];
TestData.FittedW(SNum+1:end,:,:)=[];
TestData.Label(SNum+1:end,:)=[];

Test.SetNum = size(TestData.Features,3);
Test.SetTick = TestData.NoiseRatio;
Test.SNum=size(TestData.Features,1);
Test.FeaturesName  = TrainData.FeaturesName;
Test.FittedW       = TestData.FittedW;
Test.BestFittedW   = TestData.BestFittedW;
Test.Label         = TestData.Label;
Test.Features      = TestData.Features;



Fitter={'MLE','MAP'};
Test.Methodes     = {};
for i=1:2
    for j=1:9
        Test.Methodes= [Test.Methodes,{[Fitter{i},' ',TestData.Methodes{j}]}];
    end
end
Train.Methodes=Test.Methodes;

