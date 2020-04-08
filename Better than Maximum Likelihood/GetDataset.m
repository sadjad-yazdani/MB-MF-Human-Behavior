
function [Train]=GetKNNDatasetFromRepository(AddFullyAgent)
if nargin<1
    AddFullyAgent=false;
end

TrainData=load('Data/Dataset.mat');

SNum=80000;
TrainData.Features(SNum+1:end,:)=[];
TrainData.Label(SNum+1:end,:)=[];

if AddFullyAgent
    MBAllData=load('Data/FullyMBDataset.mat');
    MBSNum=10000;
    MBAllData.Features(MBSNum+1:end,:)=[];
    MBAllData.Label(MBSNum+1:end,:)=[];
    
    MFAllData=load('Data/FullyMFDataset.mat');
    MFSNum=10000;
    MFAllData.Features(MFSNum+1:end,:)=[];
    MFAllData.Label(MFSNum+1:end,:)=[];
    
    TrainData.Features = [TrainData.Features   ;MBAllData.Features     ;MFAllData.Features];
    TrainData.Label    = [TrainData.Label      ;MBAllData.Label        ;MFAllData.Label ];
end

Train.SNum          = size(TrainData.Features,1);
Train.FeaturesName  = TrainData.FeaturesName;
Train.Label         = TrainData.Label;
Train.Features      = TrainData.Features;

Fitter={'MLE','MAP','CME','CMWP'};
Train.Methodes     = {};
for i=1:4
    for j=1:9
        Train.Methodes= [Train.Methodes,{[Fitter{i},' ',TrainData.Methodes{j}]}];
    end
end

